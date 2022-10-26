import StimulusFormState from 'stimulus-form-state'

export default class extends StimulusFormState {
  enableChangeControles () {
    const globalSubmitButton = document.getElementById('globalFormSubmitButton')

    super.enableChangeControles()

    if (this.hasSaveButtonTarget) this.saveButtonTarget.disabled = false
    if (globalSubmitButton) globalSubmitButton.disabled = false
  }

  disableChangeControles () {
    const globalSubmitButton = document.getElementById('globalFormSubmitButton')
    super.disableChangeControles()

    if (this.hasSaveButtonTarget) this.saveButtonTarget.disabled = true

    if (globalSubmitButton) globalSubmitButton.disabled = true
  }
}
