/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    uri: String,
    turboAction: { type: String, default: 'advance' }
  }

  initialize () {
    this.element.setAttribute('data-action', 'click->linkable-td#visit')
  }

  visit () {
    Turbo.visit(this.uriValue, { action: this.turboActionValue })
  }
}
