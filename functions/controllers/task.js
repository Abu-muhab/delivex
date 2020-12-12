const functions = require('firebase-functions')
const admin = require('firebase-admin')
const axios = require('axios').default
const { v4: uuidv4 } = require('uuid')

// delivery status values:
// pendingPickup
// pendingDelivery
// delivered

exports.getDeliveryTask = functions.https.onRequest(async (req, res) => {
  const courierId = req.query.id
  const courierLocation = req.query.location

  // check if the courier already has an active route
  const routes = await admin.firestore().collection('routes')
    .where('assignedCourier', '==', courierId)
    .where('status', '==', 'live').get()

  if (routes.docs.length > 0) {
    return res.json({
      successful: false,
      error: 'This courier has already been assigned a task'
    })
  }

  const orders = await admin.firestore().collection('orders')
    .orderBy('paymentVerificationTime', 'desc')
    .where('paymentVerified', '==', true)
    .where('orderStatus', '==', 'unassigned')
    .limit(10).get()

  if (orders.docs.length === 0 || orders.docs.length === undefined) {
    return res.json({
      successful: false,
      error: 'There are currently no orders to assign'
    })
  }

  const coordinates = []
  const pickupDeliveries = []
  const taskMap = {}

  // add base station. count index 0
  coordinates.push(courierLocation)
  taskMap[0] = {
    coords: courierLocation
  }

  let count = 1

  // prepare order coordinates array and pick-delivery pairs
  orders.docs.forEach(doc => {
    const order = doc.data().details
    order.id = doc.id
    order.ref = doc.ref

    coordinates.push(order.fromCoords)
    coordinates.push(order.toCoords)

    for (let x = count; x <= count + 1; x++) {
      const isPickup = x === count
      taskMap[x] = {
        isPickup: isPickup,
        coords: isPickup === true ? order.fromCoords : order.toCoords,
        locationName: isPickup === true ? order.fromLocationName : order.toLocationName,
        name: isPickup === true ? order.from : order.to,
        contact: isPickup === true ? order.fromContact : order.toContact,
        orderId: order.id,
        sibling: isPickup === true ? count + 1 : count,
        packageId: doc.data().packageId
      }
    }

    pickupDeliveries.push([count, count + 1])
    count += 2
  })

  // routing api payload
  const payload = {
    pickups_deliveries: pickupDeliveries,
    num_vehicles: 1,
    max_travel_distance: 100000000,
    max_delivery_per_vehicle: 5,
    depot: 0,
    coordinates: coordinates,
    API_key: 'AIzaSyDwJnts_ewa6K2miTx6LevJ97rvgWJCSsY'
  }

  // make request to routing api
  axios({
    method: 'POST',
    url: 'https://vehiclerouter.herokuapp.com/router/calculateRoutes/',
    headers: {
      'Content-Type': 'application/json'
    },
    data: payload
  }).then(response => {
    if (response.data !== undefined) {
      const route = response.data.data.routes[0]
      const routeId = uuidv4().toString().split('-').join('')
      const routeMap = {}
      const batch = admin.firestore().batch()
      route.route.forEach(routeIndex => {
        routeMap[routeIndex] = taskMap[routeIndex]
        if (routeIndex !== 0) {
          const orderRef = admin.firestore().collection('orders').doc(taskMap[routeIndex].orderId)

          // only write to file if isPickup is true to avoid double writes for pickup and deliveries
          if (taskMap[routeIndex].isPickup === true) {
            batch.update(orderRef, {
              orderStatus: 'assigned',
              deliveryStatus: 'pendingPickup',
              routeId: routeId,
              routeAssignmentTime: admin.firestore.Timestamp.now()
            })
          }
        }
      })

      batch.set(admin.firestore().collection('routes').doc(routeId), {
        route: route.route,
        routeMap: routeMap,
        status: 'live',
        assignedCourier: courierId,
        created: admin.firestore.Timestamp.now()
      })

      batch.commit().then(val => {
        return res.json({
          successful: true,
          data: {
            route: route.route,
            routeMap: routeMap
          }
        })
      })
    } else {
      return res.json({
        successful: false,
        error: 'Invalid request format'
      })
    }
  }).catch(err => {
    console.log(err)
    return res.json({
      successful: false,
      error: 'Something went wrong....'
    })
  })
})

exports.verifyPickup = functions.https.onRequest(async (req, res) => {
  const packageId = req.query.packageId
  const code = req.query.code
  const positionInRoute = req.query.positionInRoute

  const querySnap = await admin.firestore().collection('orders').where('packageId', '==', packageId).get()
  if (querySnap.docs.length === 0) {
    return res.json({
      successful: false,
      error: 'Invalid packageId'
    })
  }

  if (querySnap.docs[0].data().pickupVerificationCode === code) {
    const routeId = querySnap.docs[0].data().routeId
    const routeSnap = await admin.firestore().collection('routes').doc(routeId).get()
    const routeData = routeSnap.data()
    routeData.routeMap[positionInRoute].status = 'completed'

    const batch = admin.firestore().batch()

    batch.update(routeSnap.ref, routeData)
    batch.update(querySnap.docs[0].ref, {
      deliveryStatus: 'pendingDelivery'
    })

    return batch.commit().then(val => {
      return res.json({
        successful: true,
        message: 'Verification code matches'
      })
    })
  } else {
    return res.json({
      successful: false,
      error: 'Verification code is invalid'
    })
  }
})
