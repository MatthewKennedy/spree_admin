import StimulusTomSelect from './stimulus_tom_select'
import { get } from '../../utilities/request_utility'
import { deserialize } from '@matthewkennedy/json-api-deserializer'

// Connects to data-controller="ts--search"

/// //////////
// Options ///
/// //////////
// Set the endpoint name for the Platform API.    ts__search_endpoint_value: 'products'
// Set the returned option value.                 ts__search_val_value: 'slug'
// Set the returned option text.                  ts__search_txt_value: 'name'
// Fields that TomSelect searches.                ts__search_fields_value: ['name', 'sku']
// Set the name of the filter ransack fields.     ts__search_ransack_value: ['name_i_cont', 'sku_i_cont']
// Set custom params as an array within an array. ts__search_custom_params_value: [['[filter]purchasable', true], ['[filter]has_variants', true]]
// Set a string of included resources.            ts__search_include_value: 'option_types.option_values'
// Debug mode.                                    ts__search_debug_value: true

export default class extends StimulusTomSelect {
  static values = {
    uri: { type: String, default: '/api/v2/platform/' },
    endpoint: String,
    val: { type: String, default: 'id' },
    txt: { type: String, default: 'name' },
    fields: { type: Array, default: ['name'] },
    ransack: Array,
    customParams: Array,
    include: String,
    debug: { type: Boolean, default: false },
    loadThrottle: { type: Number, default: 400 },
    queryCount: { type: Number, default: 2 },
    options: { type: Array, default: [] },
    plugins: { type: Array, default: ['dropdown_input', 'search_icon'] }
  }

  initialize () {
    this.customConfigs = {
      valueField: this.valValue,
      labelField: this.txtValue,
      searchField: this.fieldsValue,
      loadThrottle: this.loadThrottleValue,
      load: (q, callback) => this.search(q, callback),
      onChange: (value) => this.doNext(value),
      shouldLoad: (query) => (query.length > this.queryCountValue)
    }
    super.initialize()
  }

  async search (q, callback) {
    const response = await get(this.buildRequestURL(q))

    if (response.ok) {
      const body = await response.json
      const deserializedData = this.requestFormatted(body)

      if (this.debugValue) console.log(deserializedData)

      callback(deserializedData)
    } else {
      console.log(response)
      callback()
    }
  }

  buildRequestURL (q) {
    const uriBase = this.uriValue + this.endpointValue
    const urlWithParams = new URL(SpreeAdmin.localizedPathFor(uriBase))

    if (this.hasRansackValue) {
      this.ransackValue.forEach(target => {
        urlWithParams.searchParams.append(`[filter]${target}`, q)
      })
    }

    if (this.hasIncludeValue) {
      urlWithParams.searchParams.append('include', this.includeValue)
    }

    if (this.hasCustomParamsValue) {
      this.customParamsValue.forEach(target => {
        urlWithParams.searchParams.append(target[0], target[1])
      })
    }

    return urlWithParams
  }

  requestFormatted (body) {
    const formatted = deserialize(body)
    return formatted
  }

  doNext (value) {
    if (this.debugValue) console.log('Override the doNext function if you need to do something special on change')
  }
}
