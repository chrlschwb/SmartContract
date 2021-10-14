const OtoCorp = artifacts.require("OtoCorp");
const Series = artifacts.require("Series");

module.exports = async (callback) => {

    const accounts = await web3.eth.getAccounts()

    console.log(accounts[0])

    try {
        const seriesDeployed = await Series.new();
        console.log(seriesDeployed.address)
        const otocorpDeployed = await OtoCorp.new(seriesDeployed.address);
        console.log(otocorpDeployed.address)
    } catch (err) {
        console.log(err)
    }

    callback()
}