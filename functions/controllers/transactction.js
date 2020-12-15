const axios = require('axios').default
const functions = require('firebase-functions')
const admin = require('firebase-admin')
const crypto = require('crypto')
const random = require('../utils/random')

exports.initializeTransaction = functions.https.onRequest((req, res) => {
  axios({
    method: 'POST',
    url: 'https://api.paystack.co/transaction/initialize',
    headers: {
      Authorization: 'Bearer sk_test_84ce7bed4e62f4f67d5ccc4d22579c65c448c8f6',
      'Content-Type': 'application/json'
    },
    data: {
      email: req.body.email,
      amount: req.body.amount * 100
    }
  }).then(response => {
    if (response.data.status === false) {
      return res.status(200).json({
        successful: false,
        message: 'Error initializing transaction'
      })
    }
    const transaction = {
      email: req.body.email,
      userId: req.body.userId,
      amount: req.body.amount,
      timeInitialized: admin.firestore.Timestamp.now(),
      details: req.body.details,
      paymentVerified: false,
      transactionReference: response.data.data.reference,
      orderStatus: 'unassigned',
      pickupVerificationCode: random.generateRandomId(),
      dropoffVerificationCode: random.generateRandomId(),
      packageId: random.generateRandomMixedId(),
      deliveryStatus: 'pendingPickup'
    }

    admin.firestore().collection('orders')
      .doc(transaction.transactionReference)
      .set(transaction)
      .then(writeResult => {
        return res.status(200).json({
          successful: true,
          message: 'Trasaction initialized',
          data: response.data
        })
      }).catch(err => {
        console.log(err)
        return res.status(200).json({
          successful: false,
          message: 'Error initializing transaction'
        })
      })
  }).catch(err => {
    console.log(err)
    return res.status(200).json({
      successful: false,
      message: 'Error initializing transaction'
    })
  })
})

exports.initializeWalletTransaction = functions.https.onRequest((req, res) => {
  axios({
    method: 'POST',
    url: 'https://api.paystack.co/transaction/initialize',
    headers: {
      Authorization: 'Bearer sk_test_84ce7bed4e62f4f67d5ccc4d22579c65c448c8f6',
      'Content-Type': 'application/json'
    },
    data: {
      email: req.body.email,
      amount: req.body.amount * 100
    }
  }).then(response => {
    if (response.data.status === false) {
      return res.status(200).json({
        successful: false,
        message: 'Error initializing transaction'
      })
    }
    const transaction = {
      email: req.body.email,
      userId: req.body.userId,
      amount: req.body.amount,
      timeInitialized: admin.firestore.Timestamp.now(),
      paymentVerified: false,
      transactionReference: response.data.data.reference
    }

    admin.firestore().collection('walletTransactions')
      .doc(transaction.transactionReference)
      .set(transaction)
      .then(writeResult => {
        return res.status(200).json({
          successful: true,
          message: 'Trasaction initialized',
          data: response.data
        })
      }).catch(err => {
        console.log(err)
        return res.status(200).json({
          successful: false,
          message: 'Error initializing transaction'
        })
      })
  }).catch(err => {
    console.log(err)
    return res.status(200).json({
      successful: false,
      message: 'Error initializing transaction'
    })
  })
})

exports.paystackHook = functions.https.onRequest(async (req, res) => {
  const event = req.body.event
  const hash = crypto.createHmac('sha512', 'sk_test_84ce7bed4e62f4f67d5ccc4d22579c65c448c8f6').update(JSON.stringify(req.body)).digest('hex')
  if (hash === req.headers['x-paystack-signature']) {
    if (event === 'charge.success') {
      if (req.body.data.status === 'success') {
        const doc = await admin.firestore().collection('orders').doc(req.body.data.reference).get()
        let col = ''

        // id doc exists, it is a delivery transaction else it is a wallet transaction
        if (doc.exists) {
          col = 'orders'
        } else {
          col = 'walletTransactions'
        }
        admin.firestore().collection(col).doc(req.body.data.reference).update({
          paymentVerified: true,
          paymentVerificationTime: admin.firestore.Timestamp.now()
        }).then(writeResult => {
          res.sendStatus(200)
        }).catch(err => {
          console.log(err)
          res.sendStatus(500)
        })
      }
    }
  } else {
    return res.status(200).json({
      message: 'You are not supposed to be here. Leemawo'
    })
  }
})

exports.calculateDeliveryFee = functions.https.onRequest((req, res) => {
  const distance = req.query.distance

  const fee = (distance / 1000) * 186

  return res.json({
    successful: true,
    data: fee
  })
})

exports.walletBalanceUpdater = functions.firestore.document('walletTransactions/{docId}').onUpdate((change, context) => {
  const data = change.after.data()
  const userId = data.userId
  const amount = data.amount
  const paymentVerified = data.paymentVerified

  if (paymentVerified === true) {
    return admin.firestore().runTransaction(async (t) => {
      const userRef = admin.firestore().collection('users').doc(userId)
      const userDoc = await t.get(userRef)
      let currentAmount = 0
      if (userDoc.data().walletBalance === undefined) {
        currentAmount = amount
      } else {
        currentAmount = userDoc.data().walletBalance + amount
      }
      t.update(userRef, {
        walletBalance: currentAmount
      })
    })
  } else {
    return 'pending verification'
  }
})
