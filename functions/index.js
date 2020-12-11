const admin = require('firebase-admin')
const functions = require('firebase-functions')
admin.initializeApp()
const transactionController = require('./controllers/transactction')
const authController = require('./controllers/auth')
const taskController = require('./controllers/task')
const random = require('./utils/random')

// transactions
exports.initializeTransaction = transactionController.initializeTransaction
exports.paystackHook = transactionController.paystackHook

// authentications
exports.signUp = authController.signUp

// task assignment
exports.getDeliveryTask = taskController.getDeliveryTask

// eidts
exports.edit = functions.https.onRequest((req, res) => {
    admin.firestore().collection('orders').get().then(querySnap => {
        const batch = admin.firestore().batch()
        querySnap.docs.forEach(doc => {
            batch.update(doc.ref, {
                pickupVerificationCode: random.generateRandomId(),
                dropoffVerificationCode: random.generateRandomId()
            })
        })
        batch.commit().then(val => {
            return res.json({
                successful: true
            })
        })
    })
})
