// Copyright (c) 2015-present, salesforce.com, inc. All rights reserved
// Licensed under BSD 3-Clause - see LICENSE.txt or git.io/sfdc-license

import React, {Component} from 'react';
import Listbox from './Listbox';
import ListboxOption from './ListboxOption';

class SortingListboxView extends Component {
  renderDocumentation() {
    return (
      <div className="slds-p-bottom_medium">
        <h2 className="slds-text-heading_medium slds-p-vertical_medium">
          Sort a listbox
        </h2>
        <ul className="slds-list_dotted slds-p-bottom_small">
          <li>
            Use arrow keys to select an option
          </li>
          <li>
            Press Space to enter into drag mode
          </li>
          <li>
            Use arrow keys to select a new position
          </li>
          <li>
            Press Space to drop option in new position
          </li>
        </ul>
        <p>See also the <a href="https://lightningdesignsystem.com/accessibility/patterns/listbox">Lightning Design System's Accessibility Patterns</a> documentation for listboxes.</p>
      </div>
    )
  }

  renderExample() {
    let options = [];

    this.props.list_options.each( function(index, element) {
      options.push(<ListboxOption name={$(element).text()}/>)
    })

    return (
      <Listbox ariaLabel="Listbox" hasDragDrop>
        {options}
      </Listbox>
    );
  }

  render () {
    return (
      <article>
        {this.renderDocumentation()}
        {this.renderExample()}
      </article>
    );
  }
}

export default SortingListboxView;
