import React from 'react';
import ReactDOM from 'react-dom';
import Board from '../chess/Board';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Board knightPosition={[0,0]} />,
    document.getElementById('chessboard')
  )
})
