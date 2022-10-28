import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ['submitButton']
  static values = {
    delay: { default: 250, type: Number }
  }

  static debounces = [
    {
      name: 'save'
    }
  ]

  initialize () {
    this.save = this.save.bind(this)
  }

  connect () {
    useDebounce(this, { wait: this.delayValue })
    if (this.hasSubmitButtonTarget) this.submitButtonTarget.style.display = 'none'
  }

  save (event) {
    this.submitButtonTarget.click()
  }
}
