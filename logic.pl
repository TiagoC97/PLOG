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
    write('Give the line of the piece to move (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    write('Give the column of the piece to move (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !.

getPieceNewCoords(X, Y):-
  repeat,
    write('Give the line of the new position for the piece (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    write('Give the column of the new position for the piece (between 1 and 7):'),
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
  getPiece(Board, Line, Column, Piece),
  checkNewPosPiece(Board, NewLine, NewColumn, Play),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  verifyNewPosInRange(NewPiece)


  ((NewPiece)

  )
  (
    (Piece == 12,
      (
        (

        );
        (fail NAO É VALIDAAAAAAAAAAAAAAAAAAAAA)
      )
    )
  )

checkNewPosPiece(Board, NewLine, NewColumn, Play):-
  getPiece(Board, NewLine, NewColumn, NewPiece),
  (((even(Play), (NewPiece =\= 12 , NewPiece =\= 13 , NewPiece =\= 14)) ;
   (odd(Play), (NewPiece =\= 22 , NewPiece =\= 23 , NewPiece =\= 24))) ;
   nl, write('WARNING! Cannot capture your own pieces!'), nl, nl, !, fail).

verifyNewPosInRange(00, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      (((NewLine =:= Line); (NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column); (NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail) ;

  ((Piece == 13 ; Piece == 23),
      (((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1); (NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail) ;

  ((Piece == 14 ; Piece == 24),
      (((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3); (NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3); (NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail).

verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      ((NewPiece == 37), nl, write('WARNING! Cannot capture all turns with 2-space!'), nl, nl, !, fail);
      (((NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail)) ;

  ((Piece == 13 ; Piece == 23),
      (((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail) ;

  ((Piece == 14 ; Piece == 24),
      (((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail).

auxLine(Line, Column, Board, 0).

auxLine(Line, Column, Board, C):-
  (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
  getPiece(Board, Line, Column + C1, Piece),
  ((((Piece == 00) ; (Piece == 36) ; (((C > 0), (Piece == 32)) ; ((C < 0), (Piece == 33)))), auxLine(Line, Column + C1, Board, C1)) ;
  nl, write('WARNING! Something is in the way!'), nl, nl, !, fail).

auxColumn(Line, Column, Board, 0).

auxColumn(Line, Column, Board, C):-
    (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
    getPiece(Board, Line + C1, Column, Piece),
    ((((Piece == 00) ; (Piece == 35) ; (((C > 0), (Piece == 34)) ; ((C < 0), (Piece == 31)))), auxLine(Line + C1, Column, Board, C1)) ;
    nl, write('WARNING! Something is in the way!'), nl, nl, !, fail).

verifyDiagonalWay(Line, Column, Board, 0, 0).

verifyDiagonalWay(Line, Column, Board, LineC, ColC):-
    ((LineC > 0), (ColC > 0),
        )


verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board):-


    (((Line == NewLine), abs(NewColumn - Column) > 1, auxLine(Line, Column, Board, (NewColumn - Column))) ;
     ((Column == NewColumn), abs(NewLine - Line) > 1, auxColumn(Line, Column, Board, (NewLine - Line))) ;
     (verifyDiagonalWay(Line, Column, Board, (NewLine - Line), (NewColumn - Column)));
     (((abs(NewColumn - Column) == 1) , (Line == NewLine)) ; ((abs(NewLine - Line) == 1) , (Column == NewColumn)))).





















  .
