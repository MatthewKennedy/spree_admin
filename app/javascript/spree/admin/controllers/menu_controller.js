import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    const activeItem = this.element

    activeItem.closest('.nav-sidebar').classList.add('active-option')

    const navPill = activeItem.closest('.nav-pills')
    if (navPill) navPill.classList.add('show')
  }

  disconnect () {
    const activeItem = this.element

    activeItem.closest('.nav-sidebar').classList.remove('active-option')

    const navPill = activeItem.closest('.nav-pills')
    if (navPill) navPill.classList.remove('show')
  }
}
