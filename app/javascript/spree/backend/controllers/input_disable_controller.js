import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['disable', 'notice', 'container']

  checkForChanges (event) {
    if (this.handleSelectChange(event.target) === true) {
      this.enforceChangedState()
    } else {
      this.disableChangedState()
    }
  }

  enforceChangedState () {
    if (this.hasContainerTarget) {
      this.containerTarget.style.display = 'none'
    }

    if (this.hasDisableTarget) {
      this.disableTargets.forEach((formEl) => {
        formEl.disabled = true
      })
    }

    if (this.hasNoticeTarget) {
      this.noticeTarget.style.display = 'block'
    }
  }

  disableChangedState () {
    if (this.hasContainerTarget) {
      this.containerTarget.style.display = 'block'
    }

    if (this.hasDisableTarget) {
      this.disableTargets.forEach((formEl) => {
        formEl.disabled = false
      })
    }

    if (this.hasNoticeTarget) {
      this.noticeTarget.style.display = 'none'
    }
  }

  handleSelectChange (selectEl) {
    let hasChanged
    let defaultSelected
    let i
    let optionsCount
    let option

    for (i = 0, optionsCount = selectEl.options.length; i < optionsCount; i++) {
      option = selectEl.options[i]

      hasChanged = hasChanged || (option.selected !== option.defaultSelected)
      if (option.defaultSelected) defaultSelected = i
    }

    if (hasChanged && !selectEl.multiple) hasChanged = (defaultSelected !== selectEl.selectedIndex)
    if (hasChanged) return true
  }
}
