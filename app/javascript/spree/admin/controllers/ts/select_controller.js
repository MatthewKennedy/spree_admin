import StimulusTomSelect from './stimulus_tom_select'
import { createPopper } from '@popperjs/core'

// Connects to data-controller="ts--select"
export default class extends StimulusTomSelect {
  initialize () {
    this.config = {
      maxOptions: 500,
      plugins: ['dropdown_input', 'no_backspace_delete', 'conditional_search', 'change_listener'],
      onInitialize: function () {
        this.popper = createPopper(this.control, this.dropdown, {
          modifiers: [
            {
              name: 'offset',
              options: {
                offset: [0, 5]
              }
            }
          ]
        })
      },
      onDropdownOpen: function () {
        this.popper.update()
      }
    }
  }
}
