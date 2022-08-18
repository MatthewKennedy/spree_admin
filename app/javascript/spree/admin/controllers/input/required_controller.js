import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['saveButton']
  static values = {
    saveButtonId: String
  }

  connect () {
    if (this.isFormValid()) return

    this.attachActionAttributes()
  }

  attachActionAttributes () {
    this.element.querySelectorAll('input, select').forEach(target => {
      if (target.hasAttribute('data-action')) {
        if (target.dataset.action.includes(`${this.identifier}#isFormValid`)) return
      }

      if (target.hasAttribute('data-action')) {
        target.setAttribute('data-action', `${this.identifier}#isFormValid ${target.dataset.action}`)
      } else {
        target.setAttribute('data-action', `${this.identifier}#isFormValid`)
      }
    })
  }

  manipulateDom (valid) {
    if (valid === true) {
      if (this.hasSaveButtonIdValue) {
        const externalSubmit = document.querySelector(`#${this.saveButtonIdValue}`)
        externalSubmit.disabled = false
      }

      if (this.hasSaveButtonTarget) this.saveButtonTarget.disabled = false
    } else {
      if (this.hasSaveButtonIdValue) {
        const externalSubmit = document.querySelector(`#${this.saveButtonIdValue}`)
        externalSubmit.disabled = true
      }
      if (this.hasSaveButtonTarget) this.saveButtonTarget.disabled = true
    }
  }

  isFormValid () {
    const valid = this.element.checkValidity()
    this.manipulateDom(valid)

    return valid
  }
}
