import { Controller } from '@hotwired/stimulus'
import { Editor } from '@tiptap/core'
import StarterKit from '@tiptap/starter-kit'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'

export default class extends Controller {
  static targets = ['input', 'boldBtn', 'italicBtn', 'strikeBtn', 'paragraphBtn', 'headingOneBtn', 'headingTwoBtn',
    'headingThreeBtn', 'headingFourBtn', 'headingFiveBtn', 'headingSixBtn', 'undoBtn', 'redoBtn', 'linkBtn', 'unlinkBtn',
    'horizontalRuleBtn', 'blockquoteBtn', 'bulletListBtn', 'orderedListBtn']

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
        Image,
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

    // Paragraph
    if (this.hasParagraphBtnTarget) {
      if (this.editor.isActive('paragraph')) {
        this.paragraphBtnTarget.classList.add('is-active')
      } else {
        this.paragraphBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 1
    if (this.hasHeadingOneBtnTarget) {
      if (this.editor.isActive('heading', { level: 1 })) {
        this.headingOneBtnTarget.classList.add('is-active')
      } else {
        this.headingOneBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 2
    if (this.hasHeadingTwoBtnTarget) {
      if (this.editor.isActive('heading', { level: 2 })) {
        this.headingTwoBtnTarget.classList.add('is-active')
      } else {
        this.headingTwoBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 3
    if (this.hasHeadingThreeBtnTarget) {
      if (this.editor.isActive('heading', { level: 3 })) {
        this.headingThreeBtnTarget.classList.add('is-active')
      } else {
        this.headingThreeBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 4
    if (this.hasHeadingFourBtnTarget) {
      if (this.editor.isActive('heading', { level: 4 })) {
        this.headingFourBtnTarget.classList.add('is-active')
      } else {
        this.headingFourBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 5
    if (this.hasHeadingFiveBtnTarget) {
      if (this.editor.isActive('heading', { level: 5 })) {
        this.headingFiveBtnTarget.classList.add('is-active')
      } else {
        this.headingFiveBtnTarget.classList.remove('is-active')
      }
    }

    // Heading Level 6
    if (this.hasHeadingSixBtnTarget) {
      if (this.editor.isActive('heading', { level: 6 })) {
        this.headingSixBtnTarget.classList.add('is-active')
      } else {
        this.headingSixBtnTarget.classList.remove('is-active')
      }
    }

    // Block Quote
    if (this.hasBlockquoteBtnTarget) {
      if (this.editor.isActive('blockquote')) {
        this.blockquoteBtnTarget.classList.add('is-active')
      } else {
        this.blockquoteBtnTarget.classList.remove('is-active')
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

  addImage () {
    event.preventDefault()
    const url = window.prompt('URL')

    if (url) {
      this.editor.chain().focus().setImage({ src: url }).run()
    }

    if (!this.editor) {
      return null
    }

    return this.editor
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

    this.editor.chain().focus()[event.params.buttonAction](event.params.buttonActionArgs).run()
    this.updateButtonState()
  }

  disconnect () {
    this.editor.destroy()
  }
}
