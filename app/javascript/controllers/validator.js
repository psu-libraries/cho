export default class Validator {
  constructor (element) {
    this.element = element
  }

  // WARNING: jQuery dependency ahead!
  // It was just a lot easier to write this using jQuery than to use XMLHttpRequest
  call () {
    $.ajaxSetup({
      headers: { 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content') }
    })

    this.resetMessage()

    $.post(this.element.dataset.url, { value: this.element.value })
      .done((data) => {
        if (!data.valid) { this.setMessage(data.errors) }
      })
      .fail(() => {
        this.setMessage(Array('Unable to validate input'))
      })
  }

  resetMessage () {
    let currentMessage = this.element.parentElement.querySelector('.' + this.constructor.messageSelectorClass)
    if (currentMessage) { currentMessage.remove() }
    this.element.closest('form').querySelector('input[type="submit"]').disabled = false
  }

  setMessage (errors) {
    let node = document.createElement('p')
    node.classList.toggle(this.constructor.messageSelectorClass)
    let content = document.createTextNode(errors.join('<br/>'))
    node.appendChild(content)
    this.element.parentElement.appendChild(node)
    this.element.closest('form').querySelector('input[type="submit"]').disabled = true
  }

  static get messageSelectorClass () {
    return 'error-invalid'
  }
}
