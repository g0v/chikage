require! webpack
require! path

module.exports =
  devtool: 'eval-source-map'
  entry:
    main:
      * 'webpack/hot/dev-server'
      * './client.ls'
  output:
    path: './'
    filename: 'client.js'
    publicPath: ''
  plugins:
    * new webpack.HotModuleReplacementPlugin
    * new webpack.NoErrorsPlugin
    * new webpack.DefinePlugin do
        __PRODUCTION__: JSON.stringify process.env.NODE_ENV is \production
  resolve:
    extensions: ['', '.js', '.ls']
  module:
    loaders:
      * test: /\.ls$/
        loaders: <[react-hot livescript]>
        excludes: [/node_modules/]
      * test: /\.styl/
        loaders: <[style css stylus]>

