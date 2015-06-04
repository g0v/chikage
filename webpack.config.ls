require! {
  'webpack'
  'path'
  #'extract-text-webpack-plugin': ExtractTextPlugin
}

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
    #* new ExtractTextPlugin 'client.css'
    * new webpack.DefinePlugin do
        __PRODUCTION__: JSON.stringify process.env.NODE_ENV is \production
  resolve:
    extensions: ['', '.js', '.ls']
  module:
    loaders:
      * test: /\.ls$/
        loaders: <[react-hot livescript]>
        excludes: [/node_modules/]
      * test: /\.css$/
        loaders: <[style css autoprefixer]>
      * test: /\.styl$/
        loaders: <[style css autoprefixer stylus]>

