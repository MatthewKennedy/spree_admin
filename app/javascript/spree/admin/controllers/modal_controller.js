/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['mainForm']

  connect () {
    this.modal = new bootstrap.Modal(this.element, {
      keyboard: false
    })
    this.modal.show()
  }

  disconnect () {
    this.modal.dispose()
  }

  submitEnd (event) {
    if (event.detail.success) this.modal.hide()
  }

  closeOnSubmit () {
    if (this.mainFormTarget.hasAttribute('data-action')) {
      this.mainFormTarget.setAttribute('data-action', `turbo:submit-end->modal#submitEnd ${this.mainFormTarget.dataset.action}`)
    } else {
      this.mainFormTarget.setAttribute('data-action', 'turbo:submit-end->modal#submitEnd')
    }
  }
}
