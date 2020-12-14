const admin = require('firebase-admin')
admin.initializeApp()
const transactionController = require('./controllers/transactction')
const authController = require('./controllers/auth')
const taskController = require('./controllers/task')
const functions = require('firebase-functions')
const random = require('./utils/random')

// transactions
exports.initializeTransaction = transactionController.initializeTransaction
exports.paystackHook = transactionController.paystackHook
exports.calculateDeliveryFee = transactionController.calculateDeliveryFee
exports.initializeWalletTransaction = transactionController.initializeWalletTransaction

// authentications
exports.signUp = authController.signUp

// task assignment
exports.getDeliveryTask = taskController.getDeliveryTask

// task verification
exports.verifyPickup = taskController.verifyPickup
exports.verifyDropoff = taskController.verifyDropoff
exports.routeCompletedChecker = taskController.routeCompletedChecker

// temp
exports.edit = functions.https.onRequest((req, res) => {
    admin.firestore().collection('orders').get().then(querySnap => {
        const batch = admin.firestore().batch()
        querySnap.forEach(doc => {
            batch.update(doc.ref, {
                orderStatus: 'unassigned'
            })
        })
        batch.commit().then(val => {
            return res.json({
                successful: true
            })
        })
    })
})
