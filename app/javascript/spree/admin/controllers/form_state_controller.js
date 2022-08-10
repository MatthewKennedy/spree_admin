import StimulusFormState from 'stimulus-form-state'

export default class extends StimulusFormState {
  enableChangeControles () {
    const globalSubmitButton = document.getElementById('globalFormSubmitButton')

    super.enableChangeControles()

    if (this.hasSaveButtonTarget) this.saveButtonTarget.style.display = 'inline'
    if (globalSubmitButton) globalSubmitButton.style.display = 'inline'
  }

  disableChangeControles () {
    const globalSubmitButton = document.getElementById('globalFormSubmitButton')
    super.disableChangeControles()

    if (this.hasSaveButtonTarget) this.saveButtonTarget.style.display = 'none'

    if (globalSubmitButton) globalSubmitButton.style.display = 'none'
  }
}
