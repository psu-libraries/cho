import React from 'react';
import ReactDOM from 'react-dom';
import Knight from '../chess/Knight';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Knight />, document.getElementById('chessboard'))
})
