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
