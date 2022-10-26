import { Controller } from '@hotwired/stimulus'
import { debounce } from 'lodash'

export default class extends Controller {
  static targets = ['submitButton']
  static values = {
    delay: { default: 250, type: Number }
  }

  initialize () {
    this.save = this.save.bind(this)
  }

  connect () {
    if (this.hasSubmitButtonTarget) this.submitButtonTarget.style.display = 'none'
    this.save = debounce(this.save, this.delayValue)
  }

  save (event) {
    this.submitButtonTarget.click()
  }
}
