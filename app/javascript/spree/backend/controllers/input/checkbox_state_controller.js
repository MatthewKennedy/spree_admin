import CheckboxSelectAll from 'stimulus-checkbox-select-all'

export default class extends CheckboxSelectAll {
  static targets = ['checkboxAll', 'checkbox', 'actionPanel', 'initialPanel']

  initialize () {
    super.initialize()
    this.reportState = this.reportState.bind(this)
  }

  connect () {
    super.connect()
    this.checkboxAllTarget.addEventListener('change', this.reportState)
    this.checkboxTargets.forEach(checkbox => checkbox.addEventListener('change', this.reportState))

    // this.reportState()
  }

  disconnect () {
    super.disconnect()
    this.checkboxAllTarget.removeEventListener('change', this.reportState)
    this.checkboxTargets.forEach(checkbox => checkbox.removeEventListener('change', this.reportState))
  }

  reportState () {
    if (this.checkboxAllTarget.checked || this.checkboxAllTarget.indeterminate) {
      this.activateOptionsPanel()
    } else {
      this.deactivateOptionsPanel()
    }
  }

  activateOptionsPanel () {
    this.actionPanelTargets.forEach(panel => { panel.style.display = 'flex' })
    this.initialPanelTargets.forEach(panel => { panel.style.display = 'none' })
  }

  deactivateOptionsPanel () {
    this.actionPanelTargets.forEach(panel => { panel.style.display = 'none' })
    this.initialPanelTargets.forEach(panel => { panel.style.display = 'flex' })
  }
}
