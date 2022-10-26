import resolve from '@rollup/plugin-node-resolve'
import commonjs from '@rollup/plugin-commonjs'
import { terser } from 'rollup-plugin-terser'
import postcss from 'rollup-plugin-postcss'

const terserOptions = {
  mangle: false,
  compress: false,
  format: {
    beautify: true,
    indent_level: 2
  }
}

const postCssOptions = {
  minimize: true,
  modules: false,
  extract: true,
  config: {
    plugins: [
      require('postcss-import'),
      require('postcss-nesting'),
      require('autoprefixer'),
      require('postcss-preset-env')({
        browsers: ['last 2 versions', '> 5%']
      })
    ]
  }
}

export default [

  // CSS
  {
    input: './postcss_styles.js',
    output: [
      {
        name: 'CSS For Rails Gem',
        file: 'app/assets/stylesheets/spree_admin.css',
        inlineDynamicImports: true,
        format: 'es',
        sourcemap: true
      },
      {
        name: 'CSS For NPM',
        file: 'dist/css/spree_admin.css',
        inlineDynamicImports: true,
        format: 'es',
        sourcemap: true
      }
    ],
    plugins: [
      postcss(postCssOptions)
    ]
  },

  // JAVASCRIPT
  {
    input: 'app/javascript/spree/backend/index.js',
    output: [
      {
        name: 'UDM JavaScript For NPM',
        file: 'dist/js/spree_admin.js',
        format: 'umd',
        inlineDynamicImports: true,
        sourcemap: true
      },
      {
        name: 'ESM JavaScript For NPM',
        file: 'dist/js/spree_admin.esm.js',
        format: 'es',
        inlineDynamicImports: true,
        sourcemap: true
      }
    ],
    plugins: [
      resolve(),
      commonjs(),
      terser(terserOptions)
    ]
  }
]
