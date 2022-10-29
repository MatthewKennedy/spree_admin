import StimulusTomSelect from './stimulus_tom_select'
import { get } from '../../utilities/request_utility'
import { deserialize } from 'deserialize-json-api'

// Connects to data-controller="ts--search"
export default class extends StimulusTomSelect {
  static values = {
    uri: String, // Set the uri for the API Example: '/api/v2/platform/variants'
    val: { type: String, default: 'id' }, // Set the value, the default is 'id' but this can be overridden Example: 'order_number'
    txt: { type: String, default: 'name' }, // Set the visible text in the option, the default is 'name' but this can be overridden Example: 'pretty_name'
    fields: { type: Array, default: ['name'] }, // Set the name of the returned fields that Tom Select searches on, the default is ['name'] Example: '['name', 'sku']'
    ransack: Array, // Set the name of the filter ransack fields Example: '['name_i_cont', 'sku_i_cont']'
    customParams: Array, // Set custom params as an array within an array Example: [ ['[filter]purchasable', true], ['[filter]eligible, true] ]
    include: String, // Set a string of included resources as you would in the api docs Example: 'images,stock_items.stock_location'
    debug: { type: Boolean, default: false }, // Debug mode can be set to log out your response helping you debug.
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
    const urlWithParams = new URL(SpreeAdmin.pathFor(this.uriValue))

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
    console.log('Override the doNext function if you need to do something special on change')
  }
}
