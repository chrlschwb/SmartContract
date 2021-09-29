const OtoCorp = artifacts.require('OtoCorp');
const Token = artifacts.require('SeriesToken');
const Series = artifacts.require('Series');

module.exports = async function (deployer, network, accounts) {
  if (network.substring(0,4) == 'main') return;
  await deployer.deploy(Series);
  let series = await Series.deployed();
  await deployer.deploy(OtoCorp, series.address);
  let instance = await OtoCorp.deployed();
  console.log('Otoco Master', instance.address);
};