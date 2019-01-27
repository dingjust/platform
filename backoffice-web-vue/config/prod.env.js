let obj = process.env.NODE_ENV == 'factory'
  ? {
    NODE_ENV: '"production"',
    NAV: '"FACTORY"'
  }
  : (process.env.NODE_ENV == 'brand' ? {
    NODE_ENV: '"production"',
    NAV: '"BRAND"'
  } : {
    NODE_ENV: '"production"',
    NAV: '"TENANT"'
  });

module.exports = obj;
