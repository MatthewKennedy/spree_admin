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
    if (data.first_name || data.last_name) {
      return `<div>
                <div>
                  <span class="text-muted">Name:</span> ${data.first_name ? escape(data.first_name) : ''} ${data.last_name ? escape(data.last_name) : ''}
                </div>
                <div>
                  <small><span class="text-muted">Email:</span> ${escape(data.email)} </small>
                </div>
                <div>
                  ${data.bill_address ? `<div><small><span class="text-muted">Bill To:</span> ${escape(data.bill_address.address1)}, ${escape(data.bill_address.country.iso)}</small> </div>` : ''}
                  ${data.ship_address ? `<div><small><span class="text-muted">Ship To:</span> ${escape(data.ship_address.address1)}, ${escape(data.ship_address.country.iso)}</small> </div>` : ''}
                </div>
              </div>`
    } else {
      return `<div>
                <div>
                  <span class="text-muted">Email:</span> ${escape(data.email)}
                </div>
                <div>
                  ${data.bill_address ? `<div><small><span class="text-muted">Bill To:</span> ${escape(data.bill_address.address1)}, ${escape(data.bill_address.country.iso_name)}</small> </div>` : ''}
                  ${data.ship_address ? `<div><small><span class="text-muted">Ship To:</span> ${escape(data.ship_address.address1)}, ${escape(data.ship_address.country.iso_name)}</small> </div>` : ''}
                </div>
              </div>`
    }
  }

  render_item (data, escape) {
    return `<div>${escape(data.email)}</div>`
  }
}
