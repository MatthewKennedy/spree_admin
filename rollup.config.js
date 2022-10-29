import resolve from '@rollup/plugin-node-resolve'
import { terser } from 'rollup-plugin-terser'
import postcss from 'rollup-plugin-postcss'
import commonjs from '@rollup/plugin-commonjs';
import pkg from './package.json' assert { type: 'json' }

const postCssOptions = {
  minimize: true,
  modules: false,
  extract: true,
  config: {
    plugins: [
      import('postcss-nesting'),
      import('autoprefixer')
    ]
  }
}

export default [
  { // CSS
    input: './postcss_styles.js',
    output: [{ file: './lib/assets/stylesheets/spree_admin.css' }],
    plugins: [
      postcss(postCssOptions)
    ]
  },
  { // JavaScript
    input: pkg.module,
    output: {
      file: pkg.main,
      format: 'esm',
      inlineDynamicImports: true
    },
    plugins: [
      resolve(),
      commonjs(),
      terser({
        mangle: false,
        compress: false,
        format: {
          beautify: true,
          indent_level: 2
        }
      })
    ]
  },

  {
    input: pkg.module,
    output: {
      file: 'app/assets/javascripts/spree_admin.min.js',
      format: 'es',
      inlineDynamicImports: true,
      sourcemap: true
    },
    plugins: [
      resolve(),
      commonjs(),
      terser({
        mangle: true,
        compress: true
      })
    ]
  }
]
