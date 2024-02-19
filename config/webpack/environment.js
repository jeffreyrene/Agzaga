const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  'window.jQuery': 'jquery',
  Popper: ['popper.js', 'default']
}))


module.exports = environment

# touched on 2025-05-22T22:47:02.035495Z
# touched on 2025-05-22T23:19:33.266384Z
