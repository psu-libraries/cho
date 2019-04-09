import Field from './field'

export default class FieldSet {
  constructor (element) {
    this.element = element
    this.label = this.element.getElementsByTagName('label').item(0).innerText
    this.input_groups = this.buildInputGroups
  }

  register () {
    this.registerFields()
    const adder = this.addFieldNode
    adder.addEventListener('click', () => { this.addAction(adder) })
    this.element.appendChild(adder)
  }

  registerFields () {
    for (let inputGroup of this.input_groups) {
      inputGroup.register()
    }
  }

  addAction (button) {
    this.element.insertBefore(this.newField, this.element.lastElementChild)
  }

  get newField () {
    return this.input_groups[0].clonedField
  }

  get buildInputGroups () {
    return Array.from(this.element.getElementsByClassName('ff-group'))
      .map(inputGroup => (new Field(inputGroup)))
  }

  get addFieldNode () {
    let node = document.createElement('span')
    node.className = 'ff-add'
    let content = document.createTextNode('(+) Add another ' + this.label)
    node.appendChild(content)
    return node
  }
}
