import webpack from 'webpack';
import path from 'path';
import ExtractTextPlugin from 'extract-text-webpack-plugin';

const config = {
  devtool: 'eval-source-map',
  entry: {
    main: [
      'webpack/hot/dev-server',
      './client.jsx'
    ]
  },
  output: {
    path: './',
    filename: 'bundle.js',
    publicPath: ''
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({
      __PRODUCTION__: JSON.stringify(process.env.NODE_ENV === 'production')
    })
  ],
  resolve: {
    extensions: ['', '.js', '.jsx']
  },
  module: {
    loaders: [{
      test: /\.jsx?$/,
      loaders: ['react-hot', 'babel?stage=0'],
      exclude: [/node_modules/]
    }, {
      test: /\.css$/,
      loaders: ['style', 'css', 'autoprefixer']
    }]
  }
};

export default config;
