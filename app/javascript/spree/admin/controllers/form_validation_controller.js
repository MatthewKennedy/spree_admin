import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['submitBtn', 'disableOnSubmit', 'hideOnSubmit', 'emptyOnSubmit', 'removeRequiredOnSubmit']

  connect () {
    this.submitBtnTarget.hidden = true
  }

  validate () {
    // We need to remove required attributes from all inputs
    // so that we can submit the validate action on the form.

    const requiredEls = this.element.querySelectorAll('[required]')
    requiredEls.forEach(target => (target.removeAttribute('required')))

    this.removeRequiredOnSubmitTargets.forEach(target => target.removeAttribute('required'))
    this.emptyOnSubmitTargets.forEach(target => (target.value = ''))
    this.hideOnSubmitTargets.forEach(target => (target.style.display = 'none'))
    this.disableOnSubmitTargets.forEach(target => target.setAttribute('disabled', 'disabled'))

    this.submitBtnTarget.click()
  }
}
