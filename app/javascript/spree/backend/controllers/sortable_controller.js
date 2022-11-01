import Sortable from 'stimulus-sortable'
import { patch } from '../utilities/request_utility'

export default class extends Sortable {
  async onUpdate ({ item, newIndex, oldIndex }) {
    if (!item.dataset.sortableUpdateUrl) return

    const param = this.resourceNameValue ? `${this.resourceNameValue}[${this.paramNameValue}]` : this.paramNameValue

    const data = new FormData()
    data.append(param, newIndex + 1)

    await patch(item.dataset.sortableUpdateUrl, { body: data, responseKind: this.responseKindValue })
  }

  get defaultOptions () {
    return {
      animation: 500,
      handle: '.handle'
    }
  }
}
