/* eslint-disable no-undef */

import { Controller } from '@hotwired/stimulus'

// BOOTSTRAP INSTANCE CONTROLLER
// Can be used through Stimulus Actions and Events to hide(), show(), dispose() etc. Bootstrap instances
// of Modal, offCanvas, toolTip etc, that were created by html attributes.

// USAGE
// Ensure that the Stimulus controller is mounted on the element that the Bootstrap instance is bound to.

// data-controller="bs-instance"
// data-action="resize@window->bs-instance#manipulate"
// data-bs-instance-class-value='Offcanvas'
// data-bs-instance-method-value='hide'

// If you want to trigger an action on connect use
// data-bs-instance-connection-value='show'

export default class extends Controller {
  static values = {
    class: String,
    connection: String,
    method: String
  }

  connect () {
    if (this.hasConnectionValue) {
      const obj = bootstrap[this.classValue].getOrCreateInstance(this.element)
      if (obj == null) return
      obj[this.connectionValue]()
    }
  }

  manipulate () {
    const obj = bootstrap[this.classValue].getInstance(this.element)
    if (obj == null) return
    obj[this.methodValue]()
  }
}
