import React from 'react';
import ReactDOM from 'react-dom';
import Knight from '../chess/Knight';
import Square from '../chess/Square';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Square black>
      <Knight />
    </Square>,
    document.getElementById('chessboard')
  )
})
