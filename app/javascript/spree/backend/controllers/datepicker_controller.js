import Flatpickr from 'stimulus-flatpickr'
import { Locales } from '../i18n/flatpickr'

export default class extends Flatpickr {
  static targets = ['watch']
  static values = {
    locale: String
  }

  locales = Locales

  connect () {
    this.config = {
      locale: this.localeValue,
      altInput: true,
      time_24hr: true,
      altInputClass: 'flatpickr-alt-input form-control rounded-start',
      showMonths: 1,
      onReady: function (dateObj, dateStr, fp) {
        // Hack for form-state
        fp.input.type = 'text'
        fp.input.style.display = 'none'
      }
    }
    super.connect()
  }

  change (selectedDates, dateStr, instance) {
    if (this.element.dataset.datepickerFrom) {
      const toCal = document.getElementById(this.element.dataset.targetPairId)
      toCal._flatpickr.set('minDate', selectedDates[0])
    }

    if (this.element.dataset.datepickerTo) {
      const fromCal = document.getElementById(this.element.dataset.targetPairId)
      fromCal._flatpickr.set('maxDate', selectedDates[0])
    }
  }
}
