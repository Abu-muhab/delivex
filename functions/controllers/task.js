const functions = require('firebase-functions')
const admin = require('firebase-admin')
const axios = require('axios').default
const { v4: uuidv4 } = require('uuid')

exports.getDeliveryTask = functions.https.onRequest(async (req, res) => {
  const orders = await admin.firestore().collection('orders')
    .orderBy('paymentVerificationTime', 'desc')
    .where('paymentVerified', '==', true)
    .where('orderStatus', '==', 'unassigned')
    .limit(10).get()

  const coordinates = []
  const pickupDeliveries = []
  const taskMap = {}
  const courierId = req.query.id
  const courierLocation = req.query.location

  // add base station. count index 0
  coordinates.push(courierLocation)
  taskMap[0] = {
    // coords: '8.978615699999999,7.458202999999998'
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
        sibling: isPickup === true ? count + 1 : count
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
        // if index is zero ignore becase it is the base station
        if (routeIndex !== 0) {
          routeMap[routeIndex] = taskMap[routeIndex]
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
