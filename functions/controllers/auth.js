// const axios = require('axios').default
const functions = require('firebase-functions')
const admin = require('firebase-admin')

exports.signUp = functions.https.onRequest((req, res) => {
  const email = req.query.email
  const password = req.query.password
  let record = null

  admin.auth().createUser({
    email: email,
    password: password
  }).then(rec => {
    record = rec
    return admin.firestore().collection('users').doc(record.uid).set({
      userId: record.uid,
      email: email
    })
  }).then(writeResult => {
    console.log(record)
    return res.status(200).json({
      successful: true,
      message: 'User created',
      data: record
    })
  }).catch(err => {
    console.log(err)
    return res.status(200).json({
      successful: false,
      message: 'Error creating new user',
      error: err
    })
  })
})
