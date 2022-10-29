import StimulusTomSelect from './stimulus_tom_select'
// import { computePosition, flip } from '@floating-ui/dom'

// Connects to data-controller="ts--select"
export default class extends StimulusTomSelect {
  initialize () {
    this.customConfigs = {
      maxOptions: 500
    }
    super.initialize()
  }
}
