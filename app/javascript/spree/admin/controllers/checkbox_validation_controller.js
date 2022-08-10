import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['message']

  connect () {
    let i

    const container = this.element
    const el = container.querySelectorAll('input[type="checkbox"]')
    const msg = document.getElementById('msg')
    const onChange = function (ev) {
      ev.preventDefault()
      const _this = this
      const arrVal = Array.prototype.slice.call(container.querySelectorAll('input[type="checkbox"]:checked')).map(function (cur) { return cur.value })

      if (arrVal.length <= 0) _this.checked = true
    }

    for (i = el.length; i--;) { el[i].addEventListener('change', onChange, false) }
  }
}
