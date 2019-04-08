import FieldSet from '../form_fields/field_set'
import '../form_fields/styles.css'

let field_sets = document.getElementsByClassName('ff-multiple')

for (let group of field_sets) {
  let field_set = new FieldSet(group)
  field_set.register()
}

