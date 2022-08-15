/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    uri: String,
    turboAction: { type: String, default: 'advance' }
  }

  connect () {
    this.element.setAttribute('data-action', 'click->linkable-td#visit:once')
  }

  visit () {
    Turbo.visit(this.uriValue, { action: this.turboActionValue })
  }
}
