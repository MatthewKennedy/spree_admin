import { Controller } from '@hotwired/stimulus'
import tinymce from 'tinymce'

// Theme
import 'tinymce/icons/default'
import 'tinymce/themes/silver'

// Plugins
import 'tinymce/plugins/link'
import 'tinymce/plugins/table'
import 'tinymce/plugins/image'

import 'tinymce/models/dom'

export default class extends Controller {
  static values = {
    plugins: { type: Array, default: ['image', 'link', 'table'] },
    menubar: { type: Boolean, default: false },
    toolbar: { type: String, default: 'undo redo | styleselect | bold italic link forecolor backcolor | alignleft aligncenter alignright alignjustify | table | bullist numlist outdent indent' }
  }

  initialize () {
    this.config = {
      target: this.element,
      plugins: this.pluginsValue,
      menubar: this.menubarValue,
      toolbar: this.toolbarValue

    }
  }

  connect () {
    this.rte = tinymce.init({
      setup: function (editor) {
        editor.on('NodeChange', function (e) {
          // Hack for form-state
          const event = new Event('input')
          const editorContent = this.getContent()

          e.target.targetElm.value = editorContent
          e.target.targetElm.dispatchEvent(event)
        })
      },
      ...this.config
    })
  }

  disconnect () {
    tinymce.remove()
  }
}
