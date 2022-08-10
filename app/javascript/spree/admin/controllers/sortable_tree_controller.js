import { Controller } from '@hotwired/stimulus'
import { Sortable } from 'sortablejs'
import { patch } from '../utilities/request_utility'

export default class extends Controller {
  static values = {
    resourceName: String,
    paramName: {
      type: String,
      default: 'position'
    },
    responseKind: {
      type: String,
      default: 'turbo_stream'
    },
    animation: Number,
    handle: {
      type: String,
      default: '.handle'
    },
    dragClass: {
      type: String,
      default: 'item-dragged'
    }
  }

  initialize () {
    this.end = this.end.bind(this)
  }

  connect () {
    const itemSortable = {
      ...this.options
    }

    const containers = this.element.querySelectorAll(
      '[data-sortable-tree-parent-id-value]'
    )

    for (let i = 0; i < containers.length; i++) {
      this.sTb = new Sortable(containers[i], itemSortable)
    }
  }

  disconnect () {
    this.sTb.destroy()
  }

  async end ({ item, newIndex, to }) {
    if (!item.dataset.sortableTreeUpdateUrlValue) return

    const data = {
      [item.dataset.sortableTreeResourceNameValue]: {
        new_parent_id: to.dataset.sortableTreeParentIdValue,
        new_position_idx: newIndex
      }
    }

    await patch(item.dataset.sortableTreeUpdateUrlValue, {
      body: data,
      responseKind: this.responseKindValue
    })
  }

  get options () {
    return {
      group: {
        name: 'sortable-tree',
        pull: true,
        put: true
      },
      handle: this.handleValue,
      swapThreshold: 0.5,
      emptyInsertThreshold: 8,
      dragClass: this.dragClassValue,
      draggable: '.draggable',
      animation: 350,
      forceFallback: false,
      onEnd: this.end
    }
  }
}
