// see http://vuejs-templates.github.io/webpack for documentation.
let path = require('path');

// point to nginx web root
const targetPath = '/usr/share/nginx/html';

module.exports = {
  build: {
    env: require('./prod.env'),
    index: path.resolve(__dirname, targetPath + '/index.html'),
    assetsRoot: path.resolve(__dirname, targetPath + '/'),
    assetsSubDirectory: 'static',
    assetsPublicPath: './',
    productionSourceMap: true,
    // Gzip off by default as many popular static hosts such as
    // Surge or Netlify already gzip all static assets for you.
    // Before setting to `true`, make sure to:
    // npm install --save-dev compression-webpack-plugin
    productionGzip: false,
    productionGzipExtensions: ['js', 'css'],
    // Run the build command with an extra argument to
    // View the bundle analyzer report after build finishes:
    // `npm run build --report`
    // Set to `true` or `false` to always turn it on or off
    bundleAnalyzerReport: process.env.npm_config_report
  },
  dev: {
    env: require('./dev.env'),
    port: 8081,
    autoOpenBrowser: true,
    assetsSubDirectory: 'static',
    assetsPublicPath: '',
    proxyTable: {
      '/medias': {
        target: 'https://47.106.112.137:9002',
        "secure": false,
        pathRewrite: {
          '^/medias': 'djwebservices/medias'
        }
      },
      '/logout': {
        target: 'https://47.106.112.137:9002',
        "secure": false,
        pathRewrite: {
          '^/logout': 'djwebservices/logout'
        }
      },
      '/djbackoffice': {
        target: 'https://47.106.112.137:9002',
        "secure": false,
        changeOrigin: true,
        pathRewrite: {
          '^/djbackoffice': 'djwebservices/v2/apparel-zh/tenant'
        }
      },
      '/djbrand': {
        target: 'https://47.106.112.137:9002',
        "secure": false,
        changeOrigin: true,
        pathRewrite: {
          '^/djbrand': 'djwebservices/v2/apparel-zh/brand'
        }
      },
      '/djfactory': {
        target: 'https://47.106.112.137:9002',
        "secure": false,
        changeOrigin: true,
        pathRewrite: {
          '^/djfactory': 'djwebservices/v2/apparel-zh/factory'
        }
      },
      '/authorizationserver': {
        target: 'https://47.106.112.137:9002',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/authorizationserver': 'authorizationserver'
        }
      },
      '/djwebservices': {
        target: 'https://47.106.112.137:9002',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/djwebservices': 'djwebservices/v2/apparel-zh'
        }
      }
    },
    // CSS Sourcemaps off by default because relative paths are "buggy"
    // with this option, according to the CSS-Loader README
    // (https://github.com/webpack/css-loader#sourcemaps)
    // In our experience, they generally work as expected,
    // just be aware of this issue when enabling this option.
    cssSourceMap: false
  }
};
