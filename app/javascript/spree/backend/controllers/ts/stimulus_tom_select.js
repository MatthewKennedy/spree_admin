import { Controller } from '@hotwired/stimulus'
import TomSelect from 'tom-select'
import { createPopper } from '@popperjs/core'
import TomSelectConditionalSearch from '../../vendors/ts_conditional_search'
import TomSelectSearchIcon from '../../vendors/ts_search_icon'

TomSelect.define('conditional_search', TomSelectConditionalSearch)
TomSelect.define('search_icon', TomSelectSearchIcon)

class StimulusTomSelect extends Controller {
  static values = {
    plugins: { type: Array, default: [] }
  }

  initialize () {
    this.config = {
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
      },
      plugins: this.pluginsValue,
      ...this.customConfigs
    }
  }

  connect () {
    this.element.setAttribute('autocomplete', 'random')

    // eslint-disable-next-line eqeqeq
    if (this.element.options.length && this.element.options[0].value == '') {
      if (!this.config.plugins.includes('clear_button')) this.config.plugins.push('clear_button')
    } else {
      const resetConfs = this.config.plugins.filter(a => a !== 'clear_button')
      this.config.plugins = resetConfs
    }

    if (this.element.attributes.multiple) {
      if (!this.config.plugins.includes('remove_button')) this.config.plugins.push('remove_button')
    } else {
      const resetConfs = this.config.plugins.filter(a => a !== 'remove_button')
      this.config.plugins = resetConfs
    }

    this.ts = new TomSelect(this.element, {
      ...this.config
    })
  }

  disconnect () {
    this.ts.destroy()
  }
}

export default StimulusTomSelect
