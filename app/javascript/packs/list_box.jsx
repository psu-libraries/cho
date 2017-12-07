import React from 'react';
import ReactDOM from 'react-dom';
//import { Router, Route, hashHistory, IndexRoute } from 'react-router';
//import MainLayout from './layout/Main';

import SortingListboxView from '../list_box/SortingListbox';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <SortingListboxView />,
    document.getElementById('list_box')
  )
})
