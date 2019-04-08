export default class Field {

  constructor(input_group) {
    this.input_group = input_group
  }

  register() {
    let remover = this.removeFieldNode
    try {
      remover.addEventListener('click', () => { this.removeAction(remover); });
      this.input_group.appendChild(remover)
    }
    catch(error) {
      console.log(error)
    }
  }

  removeAction(button) {
    button.parentElement.remove()
  }

  get removeFieldNode() {
    let node = document.createElement('span')
    node.className = 'ff-remove'
    let content = document.createTextNode('(-) Remove')
    node.appendChild(content)
    return node
  }

  get clonedField() {
    let group = this.input_group.cloneNode(true)
    Array.from(group.getElementsByClassName('ff-control')).forEach((input) => {
      input.value = ''
    })
    let remover = group.getElementsByClassName('ff-remove').item(0)
    remover.addEventListener('click', () => { this.removeAction(remover); });
    return group
  }

}
