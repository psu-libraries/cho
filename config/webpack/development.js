const environment = require('./environment')
const merge = require('webpack-merge')
const customConfig = require('./custom')

module.exports = merge(environment.toWebpackConfig(), customConfig)
