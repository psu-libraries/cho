import FieldSet from '../form_fields/field_set'
require('../form_fields/styles.css')

let fieldSets = document.getElementsByClassName('ff-multiple')

for (let group of fieldSets) {
  let fieldSet = new FieldSet(group)
  fieldSet.register()
}
