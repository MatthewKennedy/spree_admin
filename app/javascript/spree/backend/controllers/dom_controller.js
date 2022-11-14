import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['element']
  static values = {
    duration: { default: 500, type: Number }
  }

  removeElement () {
    this.element.classList.add('animate__fadeOut')
    setTimeout(() => this.elementTarget.remove(), this.durationValue)
  }
}
