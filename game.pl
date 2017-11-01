play(Board):-
  /*  playWhite(X1,Y1,X2,Y2, getBoard())
    playBlack
    readPlayer(player),
    read*/
    readCoords(X1, Y1, X2, Y2),
    movePiece(X1, Y1, X2, Y2, Board, NewBoard).

readCoords(X1, Y1, X2, Y2):-
  read(X1),
  read(Y1),
  read(X2),
  read(Y2).

movePiece(X1, Y1, X2, Y2, Board, NewBoard):-
    ite(savePos(X1, Y1, Piece, Board), savePos(X1, Y1, Piece, Board), write(Piece)).
    /*writePos(X1, Y1, 00, Board, IntBoard),
    writePos(X2, Y2, Piece, IntBoard, NewBoard)*/

savePos(X, Y, Piece, Board):-
    ite(savePosLine(Y, Board, Line), savePosLine(Y, Board, Line), savePosCol(X, Piece, Line)).

not(X):- X, !, fail.
not(X).

savePosLine(Y, [Head|Tail], Line):-
        Y > 0,
        Y1 is Y-1,
        append(Head, [], Line),
        savePosLine(Y1, Tail, Line).

savePosCol(X, Piece, [Head|Tail]):-
    X > 0,
    X1 is X-1,
    Piece is Head,
    savePosCol(X1, Piece, Tail).

writePos(X1, Y1, Piece, Board, IntBoard):-
    writePosLine(Y, Board, IntBoard),
    writePosCol(X, Piece, Board, IntBoard).

writePosLine(Y, [Head|Tail], IntBoard):-
    Y > 0,
    Y is Y-1,

    writePosLine(Y, Tail, IntBoard).

writePosCol(X, Piece, [Head|Tail]):-
    X > 0,
    X is X-1,
    savePosLine(X, Head, Tail).

ite(If, Then, Else):- If, !, Then.

ite(_, _, Else):- Else.
