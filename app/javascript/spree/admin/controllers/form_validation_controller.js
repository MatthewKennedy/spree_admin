import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['submitBtn', 'skipRequiredOnValidate']

  connect () {
    this.submitBtnTarget.hidden = true
  }

  validate () {
    // We need to remove html required attributes from inputs so that we can submit the form.
    this.skipRequiredOnValidateTargets.forEach(target => target.removeAttribute('required'))
    this.submitBtnTarget.click()
  }

  submitEnd () {
    // We need to add back the html required attributes from inputs that had them removed.
    this.skipRequiredOnValidateTargets.forEach(target => target.setAttribute('required', true))
  }
}
