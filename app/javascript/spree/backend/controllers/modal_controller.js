/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    // Avoid a modal opening on cache preview.
    if (document.documentElement.hasAttribute('data-turbo-preview')) {
      const modalBackdrop = document.querySelector('.modal-backdrop')
      if (modalBackdrop) modalBackdrop.remove()

      return
    }

    this.modal = new bootstrap.Modal(this.element, {
      keyboard: false
    })

    this.modal.show()
  }

  disconnect () {
    if (this.modal) this.modal.dispose()
  }

  submitEnd (event) {
    // If the form submission is a validation check, don't close the modal.
    if (event.detail.formSubmission.submitter.formNoValidate === true) return

    // When the form submission is successful and not a validation check, hide the modal.
    if (event.detail.success) this.modal.hide()
  }
}
