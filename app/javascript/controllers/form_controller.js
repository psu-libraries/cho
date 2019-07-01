// @note
// Based off of https://github.com/jorgemanrubia/rails-form-validations-example
// Overrides/modifies the default browser behaviors for HTML5 validations so that the error is displayed
// next to the offending element.
// Add the following data element to your form in order for Stimulus to include the new behavior:
//
// @example
//   <form data-controller='form'>
//     [...]
//   </form>

import { Controller } from 'stimulus'

export default class extends Controller {
  connect () {
    this.element.setAttribute('novalidate', true)
    this.element.addEventListener('blur', this.onBlur, true)
    this.element.addEventListener('submit', this.onSubmit)
    this.element.addEventListener('ajax:beforeSend', this.onSubmit)
  }

  disconnect () {
    this.element.removeEventListener('blur', this.onBlur)
    this.element.removeEventListener('submit', this.onSubmit)
    this.element.removeEventListener('ajax:beforeSend', this.onSubmit)
  }

  onBlur = (event) => {
    this.validateField(event.target)
  }

  onSubmit = (event) => {
    if (!this.validateForm()) {
      event.preventDefault()
      this.firstInvalidField.focus()
    }
  }

  validateForm () {
    let isValid = true
    // Not using `find` because we want to validate all the fields
    this.formFields.forEach((field) => {
      if (this.shouldValidateField(field) && !this.validateField(field)) isValid = false
    })
    return isValid
  }

  validateField (field) {
    if (!this.shouldValidateField(field)) { return true }
    const isValid = field.checkValidity()
    field.classList.toggle('invalid', !isValid)
    field.closest('form').querySelector('input[type="submit"]').disabled = !isValid
    this.refreshErrorForInvalidField(field, isValid)
    return isValid
  }

  shouldValidateField (field) {
    return !field.disabled && !['file', 'reset', 'submit', 'button'].includes(field.type)
  }

  refreshErrorForInvalidField (field, isValid) {
    this.removeExistingErrorMessage(field)
    if (!isValid) { this.showErrorForInvalidField(field) }
  }

  removeExistingErrorMessage (field) {
    const fieldContainer = field.closest('.input-group')
    if (!fieldContainer) { return }
    const existingErrorMessageElement = fieldContainer.querySelector('.error-required')
    if (existingErrorMessageElement) { existingErrorMessageElement.parentNode.removeChild(existingErrorMessageElement) }
  }

  showErrorForInvalidField (field) {
    field.insertAdjacentHTML('afterend', this.buildFieldErrorHtml(field))
  }

  buildFieldErrorHtml (field) {
    return `<p class="error-required">${field.validationMessage}</p>`
  }

  get formFields () {
    return Array.from(this.element.elements)
  }

  get firstInvalidField () {
    return this.formFields.find(field => !field.checkValidity())
  }
}
