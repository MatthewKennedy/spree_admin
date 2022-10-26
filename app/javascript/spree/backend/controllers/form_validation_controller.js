import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['submitBtn']

  connect () {
    this.submitBtnTarget.hidden = true
  }

  validate () {
    this.submitBtnTarget.click()
  }
}
