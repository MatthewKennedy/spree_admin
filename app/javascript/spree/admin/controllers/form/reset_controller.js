import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['resettable']

  resetForm () {
    if (this.hasResettableTarget) this.resettableTarget.reset()
  }

  clearForm () {
    const elements = this.resettableTarget.elements

    this.resettableTarget.reset()

    for (let i = 0; i < elements.length; i++) {
      const fieldType = elements[i].type.toLowerCase()

      switch (fieldType) {
        case 'text':
        case 'password':
        case 'textarea':
        case 'hidden':

          elements[i].value = ''
          break

        case 'radio':
        case 'checkbox':
          if (elements[i].checked) {
            elements[i].checked = false
          }
          break

        case 'select-one':
        case 'select-multi':
          elements[i].selectedIndex = -1
          break

        default:
          break
      }
    }
  }
}
