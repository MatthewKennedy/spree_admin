import Cleave from 'cleave.js'
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    options: { type: Object, default: {} }
  }

  connect () {
    this.cleaveInstance = new Cleave(this.element, {
      numeral: true,
      numeralThousandsGroupStyle: 'none'
    })
  }

  disconnect () {
    this.cleaveInstance.destroy()
  }
}
