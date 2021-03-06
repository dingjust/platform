// see http://vuejs-templates.github.io/webpack for documentation.
let path = require('path');

// point to nginx web root
const targetPath = '../dist';

module.exports = {
  build: {
    env: require('./prod.env'),
    index: path.resolve(__dirname, targetPath + '/index.html'),
    assetsRoot: path.resolve(__dirname, targetPath + '/'),
    assetsSubDirectory: 'static',
    assetsPublicPath: './',
    // productionSourceMap: true,
    productionSourceMap: false,
    // Gzip off by default as many popular static hosts such as
    // Surge or Netlify already gzip all static assets for you.
    // Before setting to `true`, make sure to:
    // npm install --save-dev compression-webpack-plugin
    productionGzip: true,
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
    // proxyTable: {
    //   '/resource': {
    //     target: 'https://localhost',
    //     "secure": false,
    //   },
    //   '/medias': {
    //     target: 'https://localhost:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/medias': 'djwebservices/medias'
    //     }
    //   },
    //   '/logout': {
    //     target: 'https://localhost:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/logout': 'djwebservices/logout'
    //     }
    //   },
    //   '/authorizationserver': {
    //     target: 'https://localhost:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/authorizationserver': 'authorizationserver'
    //     }
    //   },
    //   '/b2b': {
    //     target: 'https://localhost:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/b2b': 'djwebservices/v2/b2b-apparel-zh'
    //     }
    //   },
    //   '/c2b': {
    //     target: 'https://localhost:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/c2b': 'djwebservices/v2/c2b-apparel-zh'
    //     }
    //   },
    //   '/amap': {
    //     target: 'https://restapi.amap.com',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/amap': ''
    //     }
    //   },
    // },
    // proxyTable: {
    //   '/resource': {
    //     target: 'http://sc.nbyjy.net',
    //     "secure": false,
    //   },
    //   '/medias': {
    //     target: 'https://47.106.112.137:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/medias': 'djwebservices/medias'
    //     }
    //   },
    //   '/logout': {
    //     target: 'https://47.106.112.137:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/logout': 'djwebservices/logout'
    //     }
    //   },
    //   '/authorizationserver': {
    //     target: 'https://47.106.112.137:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/authorizationserver': 'authorizationserver'
    //     }
    //   },
    //   '/b2b': {
    //     target: 'https://47.106.112.137:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/b2b': 'djwebservices/v2/b2b-apparel-zh'
    //     }
    //   },
    //   '/c2b': {
    //     target: 'https://47.106.112.137:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/c2b': 'djwebservices/v2/c2b-apparel-zh'
    //     }
    //   },
    //   '/amap': {
    //     target: 'https://restapi.amap.com',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/amap': ''
    //     }
    //   },
    // },
    // proxyTable: {
    //   '/resource': {
    //     target: 'https://ht.nbyjy.net',
    //     "secure": false,
    //     changeOrigin: true
    //   },
    //   '/medias': {
    //     target: 'https://120.78.211.86:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/medias': 'djwebservices/medias'
    //     }
    //   },
    //   '/logout': {
    //     target: 'https://120.78.211.86:9002',
    //     "secure": false,
    //     pathRewrite: {
    //       '^/logout': 'djwebservices/logout'
    //     }
    //   },
    //   '/authorizationserver': {
    //     target: 'https://120.78.211.86:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/authorizationserver': 'authorizationserver'
    //     }
    //   },
    //   '/b2b': {
    //     target: 'https://120.78.211.86:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/b2b': 'djwebservices/v2/b2b-apparel-zh'
    //     }
    //   },
    //   '/c2b': {
    //     target: 'https://120.78.211.86:9002',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/c2b': 'djwebservices/v2/c2b-apparel-zh'
    //     }
    //   },
    //   '/amap': {
    //     target: 'https://restapi.amap.com',
    //     changeOrigin: true,
    //     "secure": false,
    //     pathRewrite: {
    //       '^/amap': ''
    //     }
    //   },
    // },
    proxyTable: {
      '/resource': {
        target: 'http://192.168.1.179',
        // target: 'http://sc.nbyjy.net',
        "secure": false,
      },
      '/medias': {
        target: 'https://192.168.1.179:9002',
        "secure": false,
        pathRewrite: {
          '^/medias': 'djwebservices/medias'
        }
      },
      '/logout': {
        target: 'https://192.168.1.179:9002',
        "secure": false,
        pathRewrite: {
          '^/logout': 'djwebservices/logout'
        }
      },
      '/authorizationserver': {
        target: 'https://192.168.1.179:9002',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/authorizationserver': 'authorizationserver'
        }
      },
      '/b2b': {
        target: 'https://192.168.1.179:9002',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/b2b': 'djwebservices/v2/b2b-apparel-zh'
        }
      },
      '/c2b': {
        target: 'https://192.168.1.179:9002',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/c2b': 'djwebservices/v2/c2b-apparel-zh'
        }
      },
      '/amap': {
        target: 'https://restapi.amap.com',
        changeOrigin: true,
        "secure": false,
        pathRewrite: {
          '^/amap': ''
        }
      },
    },
    // CSS Sourcemaps off by default because relative paths are "buggy"
    // with this option, according to the CSS-Loader README
    // (https://github.com/webpack/css-loader#sourcemaps)
    // In our experience, they generally work as expected,
    // just be aware of this issue when enabling this option.
    cssSourceMap: false
  }
};
