:- dynamic(play_number/1).
:- dynamic(player/1).
:- dynamic(whiteCounter/1).
:- dynamic(brownCounter/1).


startGame :-
  initialBoard(Board),
  assert(play_number(0)),
  assert(player(1)),
  assert(whiteCounter(7)),
  assert(brownCounter(1)),
  !,
  play_cicle(Board).

play_cicle(Board):-
  printBoard(Board),
  play(Board, NewBoard),
  !,
  (verifyEndGame(_),
  nextPlayer(_),
  nextPlay(_),
  play_cicle(NewBoard)).

verifyEndGame(_):-
  (whiteCounter(WC), brownCounter(BC), WC > 0, BC > 0) ;
  (((whiteCounter(WC), (WC == 0), nl, write('Brown won'), nl, nl) ; (brownCounter(BC), (BC == 0), nl, write('White won'), nl, nl)),
  !,fail).

nextPlayer(_):-
  ((player(P), P == 1, asserta(player(2)), retract(player(P))) ;
   (player(P), P == 2, asserta(player(1)), retract(player(P)))).

nextPlay(_):-
  play_number(P),
  P1 is P + 1,
  asserta(play_number(P1)),
  retract(play_number(P)).

play(Board, NewBoard):-
  repeat,
    get_play(Board, Line, Column, NewLine, NewColumn),
  !,
  move(Board, NewBoard, Line, Column, NewLine, NewColumn).



get_play(Board, Line, Column, NewLine, NewColumn):-
  tellPlayerToPlay(_),
  repeat,
    getPieceCurCoords(Column, Line),
    checkPieceFromCurrentPlayer(Board, Line, Column),
  !,
  repeat,
    getPieceNewCoords(NewColumn, NewLine),
    validateMove(Board, Line, Column, NewLine, NewColumn),
  !.

move(Board, NewBoard3, Line, Column, NewLine, NewColumn):-
  getPiece(Board, Line, Column, Piece),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  updateBoard(Line, Column, 00, Board, NewBoard),
  updateBoard(NewLine, NewColumn, Piece, NewBoard, NewBoard2),
  (((NewPiece =\= 00), verifyTypeNewPiece(NewPiece, NewBoard2, NewBoard3 )) ; append([],NewBoard2,NewBoard3)).

verifyTypeNewPiece(NewPiece, Board, NewBoard):-
  ((((NewPiece >= 30) , (NewPiece =< 37)) ; ((NewPiece >= 40) , (NewPiece =< 47))),
  captureBarragoon(Board, NewBoard)) ;
  captureOponentPiece(Board, NewBoard).

captureBarragoon(Board, NewBoard):-
  repeat,
    getBarragoonCoords(Column, Line, BarragoonFace),
    getPiece(Board, Line, Column, Piece),
    (Piece == 00),
  !,
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard).

captureOponentPiece(Board, NewBoard2):-
  ((player(Paux), Paux == 1, brownCounter(BC), BC1 is BC - 1, asserta(brownCounter(BC1)), retract(brownCounter(BC))) ;
  (player(Paux), Paux == 2, whiteCounter(WC), WC1 is WC - 1, asserta(whiteCounter(WC1)), retract(whiteCounter(WC)))),
  (whiteCounter(WC2), brownCounter(BC2), WC2 =\= 0, BC2 =\= 0),
  repeat,
    ((player(P), P == 1, nl, nl, write('Brown place your barragoon piece'), nl) ;
    (player(P), P == 2, nl, nl, write('White place your barragoon piece'), nl)),
    getBarragoonCoords(Column, Line, BarragoonFace),
    getPiece(Board, Line, Column, Piece),
    ((Piece == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail),
  !,
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
  repeat,
    ((player(P1), P1 == 1, nl, nl, write('White place your barragoon piece'), nl) ;
    (player(P1), P1 == 2, nl, nl, write('Brown place your barragoon piece'), nl)),
    getBarragoonCoords(Column2, Line2, BarragoonFace2),
    getPiece(NewBoard, Line2, Column2, Piece2),
    ((Piece2 == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail),
  !,
  updateBoard(Line2, Column2, BarragoonFace2, NewBoard, NewBoard2).

tellPlayerToPlay(_):-
  ((player(P), P == 1, write('White turn!')) ;
   (player(P), P == 2, write('Brown turn!'))), nl.

getPieceCurCoords(X, Y):-
  repeat,
    write('Give the column of the piece to move (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the piece to move (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !.


getPieceNewCoords(X, Y):-
  repeat,
    write('Give the column of the new position for the piece (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the new position for the piece (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !.

getBarragoonCoords(X, Y, Z):-
  repeat,
    write('Give the column of the new position for the barragoon piece (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the new position for the barragoon piece (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    nl,
    write('Choose the face of the barragoon piece to place:'),
    nl,
    nl,
    write('    x x x      ^ ^ ^      ---->      <----      | | |      ^ ^ ^      <--->        ^  '),
    nl,
    write('30- x x x  31- | | |  32- ---->  33- <----  34- | | |  35- | | |  36- <--->  37- < + >'),
    nl,
    write('    x x x      | | |      ---->      <----      v v v      v v v      <--->        v  '),
    nl,
    nl,
    write('    +--->      ----+        | |      ^ ^        <---+      +----      | |          ^ ^'),
    nl,
    write('40- | +->  41- --+ |  42- <-+ |  43- | +--  44- <-+ |  45- | +--  46- | +->  47- --+ |'),
    nl,
    write('    | |          v v      <---+      +----        | |      v v        +--->      ----+'),
    nl,
    getDoubleDigit(Z),
    checkBarragoonFace(Z),
  !.



checkPieceFromCurrentPlayer(Board, Line, Column):-
  getPiece(Board, Line, Column, Piece),
  % Checks if the selected position contains a piece
  ((Piece == 00, nl, write('WARNING! Cannot choose empty position!'), nl, nl, !, fail);
  % Checks if the piece selected corresponds to the player currently playing
  (((player(P), P == 1, (Piece == 12 ; Piece == 13 ; Piece == 14)) ;
   (player(P), P == 2, (Piece == 22 ; Piece == 23 ; Piece == 24))) ;
   nl, write('WARNING! Cannot choose opponent/barragoon piece!'), nl, nl, !, fail)).

validateMove(Board, Line, Column, NewLine, NewColumn):-
  getPiece(Board, Line, Column, Piece),
  checkNewPosPiece(Board, NewLine, NewColumn),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  !,
  verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn),
  !,
  verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board).


checkNewPosPiece(Board, NewLine, NewColumn):-
  getPiece(Board, NewLine, NewColumn, NewPiece),
  (((player(P), P == 1, (NewPiece =\= 12 , NewPiece =\= 13 , NewPiece =\= 14)) ;
   (player(P), P == 2, (NewPiece =\= 22 , NewPiece =\= 23 , NewPiece =\= 24))) ;
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
  ((((Piece == 00) ; (Piece == 36) ; (((C > 0), (Piece == 32)) ; ((C < 0), (Piece == 33)))), auxLine(Line, Column, Board, C1)) ;
  !, fail).

auxColumn(Line, Column, Board, 1).
auxColumn(Line, Column, Board, -1).

auxColumn(Line, Column, Board, C):-
    (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
    NewLine is Line + C1,
    getPiece(Board, NewLine, Column, Piece),
    ((((Piece == 00) ; (Piece == 35) ; (((C > 0), (Piece == 34)) ; ((C < 0), (Piece == 31)))), auxColumn(Line, Column, Board, C1)) ;
    !, fail).

verifyCurve(Line, Column, Board, LineC, ColC):-
    getPiece(Board, Line, Column, Piece),
    ((Piece == 37);
    (Piece == 00);
    ((LineC == 1), (ColC > 1), (Piece == 46));
    ((LineC == 1), (ColC < -1), (Piece == 40));
    ((LineC == -1), (ColC > 1), (Piece == 42));
    ((LineC == -1), (ColC < -1), (Piece == 44));
    ((LineC > 1), (ColC == 1), (Piece == 41));
    ((LineC < -1), (ColC == 1), (Piece == 47));
    ((LineC > 1), (ColC == -1), (Piece == 45));
    ((LineC < -1), (ColC == -1), (Piece == 43))).


verifyDiagonalWay(Line, Column, Board, LineC, ColC):-
    ((ColC > 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, 1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC > 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, 1, ColC), auxLine(NewLine, Column, Board, ColC));
    ((ColC < 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, -1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC < 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, -1, ColC), auxLine(NewLine, Column, Board, ColC)).


verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board):-
    (((Line == NewLine), ColC is (NewColumn - Column), auxLine(Line, Column, Board, ColC)) ;
     ((Column == NewColumn), LineC is (NewLine - Line), auxColumn(Line, Column, Board, LineC)) ;
     (ColC is (NewColumn - Column), LineC is (NewLine - Line), verifyDiagonalWay(Line, Column, Board, LineC, ColC)) ;
     nl, write('WARNING! Something is in the way!'), nl, nl, !, fail).









% PARTE MAIS LIXADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


verifyValidMoves(Board, ValidMoves, numValidMoves) :-
    player(P),
    ((P==1, whiteCounter(PC), P1 is 2); (P==2, brownCounter(PC), P1 is 1)),
    verifyPiecesLine(Board, 9, P1, Pieces),
    verifyPiecesValidMoves(Board, Pieces, PC).

verifyPiecesValidMoves(Board, Pieces, 0).

verifyPieceValidMoves(Board, Pieces, N) :-
    N > 0,
    getCoordsFromList(Pieces, N, Line, Col),

    N1 is N - 1,
    verifyPieceValidMoves(Board, Pieces, N1).

verifyPiecesLine(Board, 0, Player, Pieces).

verifyPiecesLine(Board, Line, Player, Pieces) :-
    Line > 0,
    verifyPiecesCol(Board, Line, 7, Player, Pieces),
    Line1 is Line - 1,
    verifyPiecesLine(Board, Line1, Player, Pieces).

verifyPiecesCol(Board, Line, 0, Player, Pieces).

verifyPiecesCol(Board, Line, Col, Player, Pieces) :-
    Col > 0,
    getPiece(Board, Line, Col, Piece),
    (((Player == 1, (Piece == 12; Piece == 13; Piece == 14), append([Line, Col], Pieces, Pieces2)));
    ((Player == 2, (Piece == 22; Piece == 23; Piece == 24, append([Line, Col], Pieces, Pieces2))));
    (append([], Pieces, Pieces2))),
    Col1 is Col - 1,
    verifyPiecesCol(Board, Line, Col1, Player, Pieces2).
