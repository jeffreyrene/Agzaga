process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

# touched on 2025-05-22T21:34:20.232966Z
# touched on 2025-05-22T23:39:17.607571Z
