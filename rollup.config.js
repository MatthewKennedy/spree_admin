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
  {
    input: 'app/javascript/spree/backend/index.js',
    output: [
      // Outputs for Rails Gem and live SCSS in development mode with yarn watch
      {
        file: 'app/assets/stylesheets/spree_admin.css',
        inlineDynamicImports: true,
        format: 'es',
        sourcemap: true
      },

      // Outputs for NPM package
      {
        file: 'dist/css/spree_admin.css',
        inlineDynamicImports: true,
        format: 'es',
        name: 'SpreeAdminCSS',
        sourcemap: true
      },
      {
        file: 'dist/js/spree_admin.js',
        format: 'umd',
        name: 'SpreeAdminJs',
        inlineDynamicImports: true,
        sourcemap: true
      },
      {
        file: 'dist/js/spree_admin.esm.js',
        format: 'es',
        name: 'SpreeAdminEsm',
        inlineDynamicImports: true,
        sourcemap: true
      }
    ],
    plugins: [
      postcss(postCssOptions),
      resolve(),
      commonjs(),
      terser(terserOptions)
    ]
  }
]
