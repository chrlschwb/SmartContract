const OtoCorp = artifacts.require("OtoCorp");

module.exports = async (callback) => {

    try {
    await OtoCorp.new('0x13841f9d3e2a441800b209aad3020308edd6c328');
    } catch (err) {
        console.log(err)
    }

    callback()
}