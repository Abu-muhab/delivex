const admin = require('firebase-admin')
admin.initializeApp()
const transactionController = require('./controllers/transactction')
const authController = require('./controllers/auth')

// transactions
exports.initializeTransaction = transactionController.initializeTransaction
exports.paystackHook = transactionController.paystackHook

// authentications
exports.signUp = authController.signUp
