import React from 'react';
import ReactDOM from 'react-dom';
import Board from '../chess/Board';
import { observe } from '../chess/Game';

document.addEventListener('DOMContentLoaded', () => {
  const chessBoard = document.getElementById('chessboard');

  observe(knightPosition =>
    ReactDOM.render(
      <Board knightPosition={knightPosition} />,
      chessBoard
    )
  );
})
