export default function (pluginOptions) {
  this.hook('after', 'setup', function () {
    const optionsCount = Object.keys(this.options).length

    if (optionsCount < 10) this.dropdown.classList.add('hideSearchInput')
  })
}
