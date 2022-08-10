import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    const activeItem = this.element

    activeItem.closest('.nav-sidebar').classList.add('active-option')
    activeItem.closest('.nav-pills').classList.add('show')
  }

  disconnect () {
    const activeItem = this.element

    activeItem.closest('.nav-sidebar').classList.remove('active-option')
    activeItem.closest('.nav-pills').classList.remove('show')
  }
}
