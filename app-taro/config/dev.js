module.exports = {
  env: {
    NODE_ENV: '"development"'
  },
  defineConstants: {},
  mini: {},
  h5: {
    esnextModules: ["taro-ui"],
    devServer: {
      port: 10086,
      proxy: {
        "/resource": {
          target: "https://ht.nbyjy.net",
          secure: false
        },
        "/medias": {
          target: "https://120.78.211.86:9002",
          secure: false,
          pathRewrite: {
            "^/medias": "djwebservices/medias"
          }
        },
        "/logout": {
          target: "https://120.78.211.86:9002",
          secure: false,
          pathRewrite: {
            "^/logout": "djwebservices/logout"
          }
        },
        "/authorizationserver": {
          target: "https://120.78.211.86:9002",
          changeOrigin: true,
          secure: false,
          pathRewrite: {
            "^/authorizationserver": "authorizationserver"
          }
        },
        "/b2b": {
          target: "https://120.78.211.86:9002",
          changeOrigin: true,
          secure: false,
          pathRewrite: {
            "^/b2b": "djwebservices/v2/b2b-apparel-zh"
          }
        },
        "/c2b": {
          target: "https://120.78.211.86:9002",
          changeOrigin: true,
          secure: false,
          pathRewrite: {
            "^/c2b": "djwebservices/v2/c2b-apparel-zh"
          }
        },
        "/amap": {
          target: "https://restapi.amap.com",
          changeOrigin: true,
          secure: false,
          pathRewrite: {
            "^/amap": ""
          }
        }
      }
    }
  }
};
