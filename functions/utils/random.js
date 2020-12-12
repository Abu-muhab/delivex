function getRandomNumber(min = 0, max = 9) {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min + 1)) + min
}

exports.generateRandomNumber = getRandomNumber

exports.generateRandomId = (length = 10) => {
    let randomString = ''
    for (let x = 0; x < length; x++) {
        randomString += getRandomNumber(0, 9).toString()
    }
    return randomString
}

const chars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'

exports.generateRandomMixedId = (lenght = 10) => {
    let randomString = ''
    for (let x = 0; x < lenght; x++) {
        randomString += chars[getRandomNumber(0, chars.length - 1)]
    }
    return randomString
}
