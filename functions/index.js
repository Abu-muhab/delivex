const admin = require('firebase-admin')
admin.initializeApp()
const transactionController = require('./controllers/transactction')
const authController = require('./controllers/auth')
const taskController = require('./controllers/task')

// transactions
exports.initializeTransaction = transactionController.initializeTransaction
exports.paystackHook = transactionController.paystackHook
exports.calculateDeliveryFee = transactionController.calculateDeliveryFee
exports.initializeWalletTransaction = transactionController.initializeWalletTransaction
exports.walletBalanceUpdater = transactionController.walletBalanceUpdater

// authentications
exports.signUp = authController.signUp

// task assignment
exports.getDeliveryTask = taskController.getDeliveryTask

// task verification
exports.verifyPickup = taskController.verifyPickup
exports.verifyDropoff = taskController.verifyDropoff
exports.routeCompletedChecker = taskController.routeCompletedChecker
