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
      amount: req.body.amount
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
      dropoffVerificationCode: random.generateRandomId()
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

exports.paystackHook = functions.https.onRequest((req, res) => {
  const event = req.body.event
  const hash = crypto.createHmac('sha512', 'sk_test_84ce7bed4e62f4f67d5ccc4d22579c65c448c8f6').update(JSON.stringify(req.body)).digest('hex')
  if (hash === req.headers['x-paystack-signature']) {
    if (event === 'charge.success') {
      if (req.body.data.status === 'success') {
        admin.firestore().collection('orders').doc(req.body.data.reference).update({
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
