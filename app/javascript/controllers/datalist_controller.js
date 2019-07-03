// @note Adds a display field feature to datalist elements that shows the selected label value adjacent
// to the selected id value in the datalist.

import { Controller } from 'stimulus'

export default class extends Controller {
  connect () {
    this.element.addEventListener('input', this.onChange)
    if (this.willDisplay) { this.resultTarget.innerText = this.currentValue }
  }

  disconnect () {
    this.element.removeEventListener('input', this.onChange)
  }

  onChange = (event) => {
    if (this.willDisplay) {
      event.target.parentElement.getElementsByTagName('span').item(0).innerText = this.selectedValue(event.target)
    }
  }

  selectedValue (input) {
    const datalist = new Map()

    for (let option of input.parentElement.querySelector('datalist').options) {
      datalist.set(option.value, option.text)
    }

    return (datalist.get(input.value) || this.placeholder)
  }

  get resultTarget () {
    return this.element.parentElement.getElementsByTagName('span').item(0)
  }

  get placeholder () {
    return (this.element.dataset.placeholder || 'Select')
  }

  get willDisplay () {
    if (this.element.dataset.display === 'false') {
      return false
    } else {
      return true
    }
  }

  get currentValue () {
    return (this.selectedValue(this.element) || this.placeholder)
  }
}
