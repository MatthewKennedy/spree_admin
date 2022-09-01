/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
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
    // If the form submission is a validation check, don't close the modal.
    if (event.detail.formSubmission.submitter.formNoValidate === true) return

    // When the form submission is successful and not a validation check, hide the modal.
    if (event.detail.success) this.modal.hide()
  }
}
