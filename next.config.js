const withTypeScript = require('@zeit/next-typescript');

module.exports = withTypeScript({
  webpack: (config) => {
    // Fixes npm packages that depend on `fs` module
    config.node = {
      fs: 'empty'
    }

    return config
  }
});
