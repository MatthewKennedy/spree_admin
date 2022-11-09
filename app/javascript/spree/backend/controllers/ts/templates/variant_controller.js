import TsSearchController from '../search_controller.js'

export default class extends TsSearchController {
  initialize () {
    super.initialize()

    this.config.render = {
      option: this.render_option,
      item: this.render_item
    }
  }

  render_option (data, escape) {
    if (data.images) {
      return `

<div class="row">
  <div class="col-auto">
    <img src="${escape(data.images[0].original_url)}" alt="${escape(data.name)}" width="50" height="50">
  </div>
  <div class="col">
    <div><span class="text-muted">Product Name:</span> ${escape(data.name)}</div>
    <div><span class="text-muted">SKU:</span> ${data.options_text}</div>
    ${data.sku ? `<div><span class="text-muted">Options:</span> ${escape(data.sku)}</div>` : ''}
    ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : '<div><span class="text-muted">On Hand:</span> Not Tracked</span></div>'}
  </div>
</div>

`
    } else {
      return `

<div class="row">
  <div class="col">
    <div><span class="text-muted">Product Name:</span> ${escape(data.name)}</div>
    <div><span class="text-muted">Options:</span> ${data.options_text}</div>
    ${data.sku ? `<div><span class="text-muted">SKU:</span> ${escape(data.sku)}</div>` : ''}
    ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : 'Not Tracked'}
  </div>
</div>

`
    }
  }

  render_item (data, escape) {
    return `<div>${data.name} | ${data.options_text}</div>`
  }
}
