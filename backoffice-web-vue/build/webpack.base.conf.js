let path = require("path");
let utils = require("./utils");
let config = require("../config");
let vueLoaderConfig = require("./vue-loader.conf");

function resolve(dir) {
  return path.join(__dirname, "..", dir);
}

module.exports = {
  entry: {
    app: ["babel-polyfill", "./src/main.js"],
    vendor_jquery: ["jquery"],
    vendor_tui_editor: ["highlight"],
    vendor_codemirror: ["codemirror"],
    vendor_tui_editor: ["tui-editor", "@toast-ui/vue-editor"],
    vendor_print_nb: ["vue-print-nb"],
  },
  output: {
    path: config.build.assetsRoot,
    filename: "[name].js",
    publicPath:
      process.env.NODE_ENV === "production"
        ? config.build.assetsPublicPath
        : config.dev.assetsPublicPath
  },
  resolve: {
    extensions: [".js", ".vue", ".json"],
    alias: {
      vue$: "vue/dist/vue.esm.js",
      "@": resolve("src"),
      mixins: resolve("src/mixins"),
      common: resolve("src/common"),
      components: resolve("src/components"),
      shared: resolve("src/views/shared"),
      backoffice: resolve("src/views/backoffice"),
      brand: resolve("src/views/brand"),
      factory: resolve("src/views/factory"),
      scss: resolve("src/scss")
    }
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: "vue-loader",
        options: vueLoaderConfig
      },
      {
        test: /\.js$/,
        loader: "babel-loader",
        include: [
          resolve("src"),
          resolve("test"),
          resolve("node_modules/element-ui/src/mixins/emitter.js")
          // resolve('node_modules/element-ui/src'),
          // resolve('node_modules/element-ui/packages'),
          // resolve('node_modules/_element-ui@2.13.2@element-ui/src'),
          // resolve('node_modules/_element-ui@2.13.2@element-ui/packages'),
        ]
      },
      {
        test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
        exclude: [/fonts/],
        use: {
          loader: "file-loader",
          options: {
            name: "[name].[hash:7].[ext]",
            publicPath: "../../",
            outputPath: utils.assetsPath("img/"),
            emitFile: true
          }
        }
      },
      {
        test: /\.(woff2?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        exclude: [/flags/],
        use: {
          loader: "file-loader",
          options: {
            name: "[name].[hash:7].[ext]",
            publicPath: "../../",
            outputPath: utils.assetsPath("fonts/")
          }
        }
      }
    ]
  },
  externals: {
    echarts: "echarts",
    xlsx: "XLSX"
  },
};
