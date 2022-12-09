import resolve from '@rollup/plugin-node-resolve'
import terser from '@rollup/plugin-terser'
import replace from '@rollup/plugin-replace'
import postcss from 'rollup-plugin-postcss'
import autoprefixer from 'autoprefixer'
import postcssnesting from 'postcss-nesting'
import pkg from './package.json'

export default [
  { // CSS
    input: './app/sass/main.scss',
    output: [{ file: './app/assets/stylesheets/spree/backend/spree_admin.min.css' }],
    plugins: [
      postcss({
        minimize: true,
        modules: false,
        extract: true,
        config: {
          plugins: [
            postcssnesting,
            autoprefixer
          ]
        }
      })
    ]
  },

  // JavaScript
  {
    input: pkg.module,
    output: {
      file: pkg.gem,
      format: 'umd',
      inlineDynamicImports: true
    },
    plugins: [
      replace({
        preventAssignment: true,
        'process.env.NODE_ENV': JSON.stringify('production')
      }),
      resolve(),
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
      file: pkg.browser,
      format: 'umd',
      inlineDynamicImports: true,
      sourcemap: true
    },
    plugins: [
      resolve(),
      replace({
        preventAssignment: true,
        'process.env.NODE_ENV': JSON.stringify('production')
      }),
      terser({
        mangle: true,
        compress: true
      })
    ]
  },
  {
    input: pkg.module,
    output: {
      file: pkg.main,
      format: 'esm',
      inlineDynamicImports: true
    },
    plugins: [
      resolve(),
      replace({
        preventAssignment: true,
        'process.env.NODE_ENV': JSON.stringify('production')
      }),
      terser({
        mangle: false,
        compress: false,
        format: {
          beautify: true,
          indent_level: 2
        }
      })
    ]
  }
]
