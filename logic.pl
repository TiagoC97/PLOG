startGame :-
initialBoard(Board),
Play is 0,
play_cicle(Board, Play).

play_cicle(Board, Play):-
  printBoard(Board),
  play(Board, NewBoard, Play),
  NewPlay is Play + 1,
  play_cicle(NewBoard, NewPlay).

play(Board, NewBoard, Play):-
  repeat,
    get_play(Board, Play, Line, Column, NewLine, NewColumn),
  !,
  move(Board, NewBoard, Play, Line, Column, NewLine, NewColumn).



get_play(Board, Play, Line, Column, NewLine, NewColumn):-
  determinePlayer(Play),
  repeat,
    getPieceCurCoords(Column, Line),
    checkPieceFromCurrentPlayer(Board, Line, Column, Play),
  !,
  repeat,
    getPieceNewCoords(NewColumn, NewLine),
    validateMove(Board, Play, Line, Column, NewLine, NewColumn),
  !.

move(Board, NewBoard, Play, Line, Column, NewLine, NewColumn):- .

determinePlayer(Play):-
  ((even(Play), write('White turn!'));
   (odd(Play), write('Brown turn!'))), nl.

getPieceCurCoords(X, Y):-
  repeat,
    write('Give the line of the piece to move (between 1 and 7):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    write('Give the column of the piece to move (between 1 and 9):'),
    getDigit(X),
    checkColumn(X),
  !.

getPieceNewCoords(X, Y):-
  repeat,
    write('Give the line of the new position for the piece (between 1 and 7):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    write('Give the column of the new position for the piece (between 1 and 9):'),
    getDigit(X),
    checkColumn(X),
  !.

checkPieceFromCurrentPlayer(Board, Line, Column, Play):-
  getPiece(Board, Line, Column, Piece),
  % Checks if the selected position contains a piece
  ((Piece == 00, nl, write('WARNING! Cannot choose empty position!'), nl, nl, !, fail);
  % Checks if the piece selected corresponds to the player currently playing
  (((even(Play), (Piece == 12 ; Piece == 13 ; Piece == 14)) ;
   (odd(Play), (Piece == 22 ; Piece == 23 ; Piece == 24))) ;
   nl, write('WARNING! Cannot choose opponent\'s piece!'), nl, nl, !, fail)).

validateMove(Board, Play, Line, Column, NewLine, NewColumn):-
  .
