import StimulusTomSelect from './stimulus_tom_select'
import { get } from '../../utilities/request_utility'
import { deserialize } from '@matthewkennedy/json-api-deserializer'

// Connects to data-controller="ts--search"
export default class extends StimulusTomSelect {
  static values = {
    uri: String, // Set the uri for the API.                                                  Example ->  ts__search_uri_value: '/api/v2/platform/products'
    val: { type: String, default: 'id' }, // Set the option value.                            Example ->  ts__search_val_value: 'slug'
    txt: { type: String, default: 'name' }, // Set the visible option text.                   Example ->  ts__search_txt_value: 'name'
    fields: { type: Array, default: ['name'] }, // Set the fields that Tom Select searches    Example ->  ts__search_fields_value: ['name', 'sku']
    ransack: Array, // Set the name of the filter ransack fields                              Example ->  ts__search_ransack_value: ['name_i_cont', 'sku_i_cont']
    customParams: Array, // Set custom params as an array within an array                     Example ->  ts__search_custom_params_value: [['[filter]purchasable', true], ['[filter]has_variants', true]]
    include: String, // Set a string of included resources as you would in the api docs.      Example ->  ts__search_include_value: 'option_types.option_values'
    debug: { type: Boolean, default: false }, // Debug mode.                                  Example ->  ts__search_debug_value: true
    loadThrottle: { type: Number, default: 400 },
    queryCount: { type: Number, default: 2 },
    options: { type: Array, default: [] },
    plugins: { type: Array, default: ['dropdown_input', 'search_icon'] } // Set an array of plugin names as per Tom Select docs.
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
    const urlWithParams = new URL(SpreeAdmin.localizedPathFor(this.uriValue))

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
