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

move(Board, NewBoard2, Play, Line, Column, NewLine, NewColumn):-
  getPiece(Board, Line, Column, Piece),
  updateBoard(00, Line, Column, Board, NewBoard),
  updateBoard(Piece, Line, Column, NewBoard, NewBoard2).

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
  !,
  verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn),
  !,
  verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board).


checkNewPosPiece(Board, NewLine, NewColumn, Play):-
  getPiece(Board, NewLine, NewColumn, NewPiece),
  (((even(Play), (NewPiece =\= 12 , NewPiece =\= 13 , NewPiece =\= 14)) ;
   (odd(Play), (NewPiece =\= 22 , NewPiece =\= 23 , NewPiece =\= 24))) ;
   nl, write('WARNING! Cannot capture your own pieces!'), nl, nl, !, fail).

verifyNewPosInRange(00, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      ((((NewLine =:= Line); (NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column); (NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail)) ;

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1); (NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail)) ;

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3); (NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3); (NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      nl, write('WARNING! Invalid move!'), nl, nl, !, fail)).

verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      (((NewPiece == 37), nl, write('WARNING! Cannot capture all turns with 2-space!'), nl, nl, !, fail);
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail)));

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail)) ;

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      nl, write('WARNING! Cannot capture with short move!'), nl, nl, !, fail)).

auxLine(Line, Column, Board, 1).
auxLine(Line, Column, Board, -1).

auxLine(Line, Column, Board, C):-
  (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
  NewColumn is Column + C1,
  getPiece(Board, Line, NewColumn, Piece),
  ((((Piece == 00) ; (Piece == 36) ; (((C > 0), (Piece == 32)) ; ((C < 0), (Piece == 33)))), auxLine(Line, NewColumn, Board, C1)) ;
  !, fail).

auxColumn(Line, Column, Board, 1).
auxColumn(Line, Column, Board, -1).

auxColumn(Line, Column, Board, C):-
    (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
    NewLine is Line + C1,
    getPiece(Board, NewLine, Column, Piece),
    ((((Piece == 00) ; (Piece == 35) ; (((C > 0), (Piece == 34)) ; ((C < 0), (Piece == 31)))), auxColumn(NewLine, Column, Board, C1)) ;
    !, fail).

verifyCurve(Line, Column, Board, LineC, ColC):-
    getPiece(Board, Line, Column, Piece),
    ((Piece == 37);
    (Piece == 00);
    ((LineC == 1), (ColC > 1), (Piece == 46));
    ((LineC == 1), (ColC < -1), (Piece == 42));
    ((LineC == -1), (ColC > 1), (Piece == 40));
    ((LineC == -1), (ColC < -1), (Piece == 44));
    ((LineC > 1), (ColC == 1), (Piece == 41));
    ((LineC < -1), (ColC == 1), (Piece == 45));
    ((LineC > 1), (ColC == -1), (Piece == 47));
    ((LineC < -1), (ColC == -1), (Piece == 43))).


verifyDiagonalWay(Line, Column, Board, LineC, ColC):-
/*
    (((ColC > 0), auxLine(Line, Column, Board, ColC), verifyCurve(Line, Column, Board, LineC, 1), auxColumn(Line, Column, Board, LineC));
    ((LineC > 0), auxColumn(Line, Column, Board, LineC), verifyCurve(Line, Column, Board, 1, ColC), auxLine(Line, Column, Board, ColC));
    ((ColC < 0), auxLine(Line, Column, Board, ColC), verifyCurve(Line, Column, Board, LineC, -1), auxColumn(Line, Column, Board, LineC));
    ((LineC < 0), auxColumn(Line, Column, Board, LineC), verifyCurve(Line, Column, Board, -1, ColC), auxLine(Line, Column, Board, ColC))).

    ((auxLine(Line, Column, Board, ColC), (((LineC > 0), AuxL is 1) ; ((LineC < 0), AuxL is -1)), verifyCurve(Line, Column, Board, AuxL, ColC), NewColumn is Column + ColC, auxColumn(Line, NewColumn, Board, LineC));
    (auxColumn(Line, Column, Board, LineC), (((ColC > 0), AuxC is 1) ; ((ColC < 0), AuxC is -1)), verifyCurve(Line, Column, Board, LineC, AuxC), NewLine is Line + LineC, auxLine(NewLine, Column, Board, ColC))).
*/
    ((ColC > 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, 1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC > 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, 1, ColC), auxLine(NewLine, Column, Board, ColC));
    ((ColC < 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, -1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC < 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, -1, ColC), auxLine(NewLine, Column, Board, ColC)).


verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board):-
    (((Line == NewLine), ColC is (NewColumn - Column), auxLine(Line, Column, Board, ColC)) ;
     ((Column == NewColumn), LineC is (NewLine - Line), auxColumn(Line, Column, Board, LineC)) ;
     (ColC is (NewColumn - Column), LineC is (NewLine - Line), verifyDiagonalWay(Line, Column, Board, LineC, ColC)) ;
     nl, write('WARNING! Something is in the way!'), nl, nl, !, fail).
