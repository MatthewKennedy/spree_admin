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
  <div class="col-auto d-flex align-items-center">
    <img src="${escape(data.images[0].original_url)}" alt="${escape(data.name)}" width="50" height="50">
  </div>
  <div class="col">
    <div><span class="text-muted">Product Name:</span> ${escape(data.name)}</div>
    <div><span class="text-muted">Options:</span> ${data.options_text}</div>
    ${data.sku ? `<div><span class="text-muted">SKU:</span> ${escape(data.sku)}</div>` : ''}
    ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : '<span class="text-muted">On Hand:</span> Not Tracked'}
  </div>
</div>

`
    } else {
      return `

<div class="row">
  <div class="col-auto d-flex align-items-center text-muted">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="50" height="50">
      <path fill="none" d="M0 0h24v24H0z"/>
      <path fill="currentColor" d="M5 11.1l2-2 5.5 5.5 3.5-3.5 3 3V5H5v6.1zm0 2.829V19h3.1l2.986-2.985L7 11.929l-2 2zM10.929 19H19v-2.071l-3-3L10.929 19zM4 3h16a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1zm11.5 7a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z"/>
    </svg>
  </div>
  <div class="col">
    <div><span class="text-muted">Product Name:</span> ${escape(data.name)}</div>
    <div><span class="text-muted">Options:</span> ${data.options_text}</div>
    ${data.sku ? `<div><span class="text-muted">SKU:</span> ${escape(data.sku)}</div>` : ''}
    ${data.total_on_hand ? `<div><span class="text-muted">On Hand:</span> ${escape(data.total_on_hand)}</div>` : '<span class="text-muted">On Hand:</span> Not Tracked'}
  </div>
</div>

`
    }
  }

  render_item (data, escape) {
    return `<div>${data.name} | ${data.options_text}</div>`
  }
}
