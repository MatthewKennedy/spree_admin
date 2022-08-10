import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['decreaseButton', 'increaseButton', 'submitBtn']

  connect () {
    const input = this.element.querySelector('input[type=number]')
    const submit = this.element.querySelector('input[type=submit]')

    this.decreaseButtonTarget.addEventListener('click', function () {
      input.stepDown()
      submit.click()
    })

    this.increaseButtonTarget.addEventListener('click', function () {
      input.stepUp()
      submit.click()
    })
  }

  disconnect () {
    this.decreaseButtonTarget.removeEventListener('click', null)
    this.increaseButtonTarget.removeEventListener('click', null)
  }
}
