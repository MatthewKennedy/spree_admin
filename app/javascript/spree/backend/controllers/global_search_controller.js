import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['form']

  connect () {
    const searchInput = document.getElementById('global_search_input')
    const el = document.querySelector('#global_search_input')
    const observer = new window.IntersectionObserver(([entry]) => {
      if (entry.isIntersecting) {
        searchInput.focus()
        return
      }
      searchInput.value = ''
      Turbo.navigator.submitForm(this.formTarget)
    }, {
      root: null,
      threshold: 1
    })
    observer.observe(el)
  }
}
