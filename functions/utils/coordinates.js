exports.convertStringToLatLng = (String coords) {
    lat = parseFloat(coords.split(',')[0])
    lng = parseFloat(coords.split(',')[1])
    return {
        lat: lat,
        lng: lng
    }
}