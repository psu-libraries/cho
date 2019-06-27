import { Application } from 'stimulus'
import FieldsController from 'fields_controller'

describe('FieldsController', () => {
  beforeEach(() => {
    document.body.innerHTML = `
    <div class="form-group" data-controller="fields">
      <label for="managed_field_id">
        Manged Field
      </label>
      <div class="input-group">
        <input type="text" id="managed_field_id">
      </div>
    </div>
    <div class="form-group">
      <label for="unmanaged_field_id">
        Unmanged Field
      </label>
      <div class="input-group">
        <input type="text" id="unmanaged_field_id">
      </div>
    </div>`

    const application = Application.start()
    application.register('fields', FieldsController)
  })

  describe('#connect', () => {
    it('inserts buttons for fields designated as multiple', () => {
      const fields = document.getElementsByClassName('form-group')

      expect(fields[0].getElementsByTagName('button').length).toEqual(1)
      expect(fields[1].getElementsByTagName('button').length).toEqual(0)
    })
  })

  describe('#addButton', () => {
    const controller = new FieldsController()
    const button = controller.addButton('Thing')

    it('creates a button to add new fields', () => {
      expect(button.getAttribute('data-action')).toEqual('fields#add')
      expect(button.innerHTML).toEqual('Add another Thing')
    })
  })

  describe('#removeButton', () => {
    const controller = new FieldsController()
    const button = controller.removeButton

    it('creates a button to remove fields', () => {
      expect(button.getAttribute('data-action')).toEqual('fields#remove')
      expect(button.innerHTML).toEqual('Remove')
    })
  })
})
