import TsSearchController from '../search_controller.js'
import { deserialize } from '@matthewkennedy/json-api-deserializer'

export default class extends TsSearchController {
  initialize () {
    super.initialize()

    this.config.render = {
      option: this.render_option,
      item: this.render_item
    }
  }

  requestFormatted (body) {
    if (body.data[0].attributes.purchasable === false) return

    const formatted = deserialize(body)
    return formatted
  }

  render_option (data, escape) {
    if (data.images) {
      return `<div class="row">
                <div class="col-auto">
                  <img src="${escape(data.images[0].original_url)}" alt="${escape(data.name)}" width="50" height="50">
                </div>
                <div class="col">
                  <div>${escape(data.name)}</div>
                  ${data.sku ? `<div><span class="text-muted">SKU:</span> ${escape(data.sku)}</div>` : ''}
                  ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : '<div><span class="text-muted">On Hand:</span> Not Tracked</span></div>'}
                </div>
              </div>`
    } else {
      return `<div class="row">
                <div class="col">
                  <div>${escape(data.name)}</div>
                  ${data.sku ? `<div><span class="text-muted">SKU:</span> ${escape(data.sku)}</div>` : ''}
                  ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : 'Not Tracked'}
                </div>
              </div>`
    }
  }

  render_item (data, escape) {
    return `<div>${data.name}</div>`
  }
}
