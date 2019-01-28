let merge = require('webpack-merge');
let prodEnv = require('./prod.env');

let obj = process.env.NODE_ENV == 'factory'
  ? {
    NODE_ENV: '"development"',
    NAV: '"FACTORY"'
  }
  : (process.env.NODE_ENV == 'brand' ? {
    NODE_ENV: '"development"',
    NAV: '"BRAND"'
  } : {
    NODE_ENV: '"development"',
    NAV: '"TENANT"'
  });

module.exports = merge(prodEnv, obj);
