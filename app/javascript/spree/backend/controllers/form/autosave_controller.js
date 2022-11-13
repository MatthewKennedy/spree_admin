import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ['submitButton', 'paramHolder']
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
    if (this.hasParamHolderTarget) {
      const fullUrl = new URL(this.submitButtonTarget.href)
      const params = fullUrl.searchParams
      const paramName = this.paramHolderTarget.name
      const paramValue = this.paramHolderTarget.value

      params.set(paramName, paramValue)

      this.submitButtonTarget.href = fullUrl.href
    }

    this.submitButtonTarget.click()
  }
}
