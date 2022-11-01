import { Controller } from '@hotwired/stimulus'
import { Editor } from '@tiptap/core'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'

export default class extends Controller {
  static targets = ['input', 'boldBtn', 'italicBtn', 'strikeBtn', 'undoBtn', 'redoBtn', 'linkBtn', 'unlinkBtn']

  initialize () {
    this.config = {}
  }

  connect () {
    const input = this.inputTarget
    const editorContent = input.value
    const inputEvent = new Event('input')

    input.style.display = 'none'

    this.editor = new Editor({
      element: this.element,
      extensions: [
        StarterKit,
        Link.configure({
          openOnClick: false
        })
      ],
      content: editorContent,
      autofocus: true,
      editable: true,
      injectCSS: true,
      onUpdate ({ editor }) {
        const html = this.getHTML()
        input.value = html.toString()
        input.dispatchEvent(inputEvent) // Allow any change listeners on the input to notice the text has changed.
      },
      onSelectionUpdate: () => this.updateButtonState()
    })
  }

  // Controlling Button State
  //
  // If the cursor is placed within bold text, the Bold button is marked as active
  // For Undo / Redo buttons a disable or not disabled state is set based on the
  // validity of use.
  updateButtonState () {
    // Bold
    if (this.hasBoldBtnTarget) {
      if (this.editor.isActive('bold')) {
        this.boldBtnTarget.classList.add('is-active')
      } else {
        this.boldBtnTarget.classList.remove('is-active')
      }
    }

    // Italic
    if (this.hasItalicBtnTarget) {
      if (this.editor.isActive('italic')) {
        this.italicBtnTarget.classList.add('is-active')
      } else {
        this.italicBtnTarget.classList.remove('is-active')
      }
    }

    // Strike
    if (this.hasStrikeBtnTarget) {
      if (this.editor.isActive('strike')) {
        this.strikeBtnTarget.classList.add('is-active')
      } else {
        this.strikeBtnTarget.classList.remove('is-active')
      }
    }

    // Undo
    if (this.hasUndoBtnTarget) {
      if (!this.editor.can().chain().focus().undo().run()) {
        this.undoBtnTarget.disabled = true
      } else {
        this.undoBtnTarget.disabled = false
      }
    }

    // Redo
    if (this.hasRedoBtnTarget) {
      if (!this.editor.can().chain().focus().redo().run()) {
        this.redoBtnTarget.disabled = true
      } else {
        this.redoBtnTarget.disabled = false
      }
    }
  }

  setLink (event) {
    event.preventDefault()
    const previousUrl = this.editor.getAttributes('link').href
    const url = window.prompt('URL', previousUrl)

    // cancelled
    if (url === null) {
      return
    }

    // empty
    if (url === '') {
      this.editor
        .chain()
        .focus()
        .extendMarkRange('link')
        .unsetLink()
        .run()

      return
    }

    // update link
    this.editor
      .chain()
      .focus()
      .extendMarkRange('link')
      .setLink({ href: url })
      .run()
  }

  buttonAction (event) {
    event.preventDefault()
    this.editor.chain().focus()[event.params.buttonAction]().run()
  }

  disconnect () {
    this.editor.destroy()
  }
}
