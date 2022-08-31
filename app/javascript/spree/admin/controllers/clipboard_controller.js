import { Controller } from '@hotwired/stimulus'
import { flashToastNotice } from '../utilities/bs_toast'

export default class extends Controller {
  static targets = ['source']

  copy (event) {
    navigator.clipboard.writeText(this.sourceTarget.value).then(() => {
      console.log('Successfully copied to clipboard')
      flashToastNotice(`Successfully copied ${this.sourceTarget.placeholder} to clipboard`)
    }, () => {
      console.log('Failed to copy clipboard')
      flashToastNotice(`Failed to copy ${this.sourceTarget.placeholder} to clipboard`)
    })
  }
}
