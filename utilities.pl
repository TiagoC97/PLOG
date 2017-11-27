:- use_module(library(lists)).
:- use_module(library(random)).

% Function used to clear screen
cls :- write('\e[2J').

% Functions to get the user input

% if after the digit/char, the user inputs other characters,
% these are ignored until the user inputs a new line (which is also ignored)

waitNewLine:- get_code(L), ite(L == 10, !, waitNewLine).

getDigit(D):- get_code(D1), D is D1 - 48, ite(D1 == 10, !, waitNewLine), !.

getDoubleDigit(D):- get_code(D1), D2 is D1 - 48, get_code(D3), D4 is D3 - 48, D is (D2*10) + D4, ite(D1 == 10, !, waitNewLine), !.

getChar(C):- get_char(C), char_code(C, C1), ite(C1 == 10, !, waitNewLine).

% Implementation of an if statement

ite(If, Then, _Else):- If, !, Then.
ite(_, _, Else):- Else.

% Determine if a given Play is even or odd
even(Play):- Play mod 2 =:= 0.

odd(Play):- Play mod 2 =:= 1.

getPiece(Board, Line, Col, Piece):-
    nth1(Line, Board, BoardLine),
    nth1(Col, BoardLine, Piece).

getCoordsFromList(List, N, Line, Col):-
    nth1(N, List, Coords),
    nth1(1, Coords, Line),
    nth1(2, Coords, Col).

% Checks if a given line is valid
checkLine(Line):-
  (Line >= 1, Line =< 9);
  nl, write('WARNING! Line must be between 1 and 9!'), nl, nl, !, fail.

% Checks if a given column is valid
checkColumn(Column):-
  (Column >= 1, Column =< 7);
  nl, write('WARNING! Column must be between 1 and 7!'), nl, nl, !, fail.

% Checks if a given barragoon face is valid
checkBarragoonFace(Face):-
  ((Face >= 30, Face =< 37) ; (Face >= 40, Face =< 47)) ;
  nl, write('WARNING! Please insert a valid barragoon face!'), nl, nl, !, fail.

% Functions used to update the game board. Putting a given piece in a given place.

updateBoard(1, Column, Piece, [FirstLine|OtherLines], [NewFirstLine|OtherLines]):-
	updateBoardOneList(Column, Piece, FirstLine, NewFirstLine).
updateBoard(Line, Column, Piece, [FirstLine|OtherLines], [FirstLine|NewOtherLines]):-
	Line > 1,
	NewLine is Line-1,
	updateBoard(NewLine, Column, Piece, OtherLines, NewOtherLines).

updateBoardOneList(1, Piece, [_|Tail], [Piece|Tail]).
updateBoardOneList(Column, Piece, [Head|Tail], [Head|NewTail]):-
	Column > 1,
	NewColumn is Column-1,
	updateBoardOneList(NewColumn, Piece, Tail, NewTail).

  removeElementsFromlist([], _, []).
  removeElementsFromlist([H|Tail], L2, Rest):- member(H, L2), !, removeElementsFromlist(Tail, L2, Rest).
  removeElementsFromlist([H|Tail], L2, [H|Rest]):- removeElementsFromlist(Tail, L2, Rest).

% Implementation of the Not predicate
not(X):- X, !, fail.
not(_X).

% Implementation of the predicate that creates a list of the made moves.

addMadeMove(Type, Line, Column, Piece, NewLine, NewColumn, NewPiece):-
    movesMade(Moves),
    ((Type \= 3, append([[Type, Line, Column, Piece, NewLine, NewColumn, NewPiece]], Moves, NewMoves)) ;
    append([[Type, NewLine, NewColumn, NewPiece]], Moves, NewMoves)),
    retract(movesMade(Moves)),
    asserta(movesMade(NewMoves)).

% Implementation of the predicate that gets the Undo command

addPieceToPlayer(PlayerMadeCapture):-
    (PlayerMadeCapture == 1, brownCounter(BC), BC1 is BC + 1, retract(brownCounter(BC)), asserta(brownCounter(BC1)));
    (PlayerMadeCapture == 2, whiteCounter(AC), AC1 is AC + 1, retract(whiteCounter(AC)), asserta(whiteCounter(AC1))).

makeUndo(Board, NewBoard2, Moves):-
    nth1(1, Moves, Move),

    nth1(1, Move, Type),

    nth1(2, Move, Line),
    nth1(3, Move, Column),
    nth1(4, Move, Piece),

    ((Type \= 3,
    nth1(5, Move, NewLine),
    nth1(6, Move, NewColumn),
    nth1(7, Move, NewPiece),
    removeFirstElement(Moves, NewMoves), retract(movesMade(Moves)),
    asserta(movesMade(NewMoves)), updateBoard(Line, Column, Piece, Board, NewBoard),
    updateBoard(NewLine, NewColumn, NewPiece, NewBoard, NewBoard2), ((Type \= 0, addPieceToPlayer(Type)) ; true)) ;
    (Type == 3, removeFirstElement(Moves, NewMoves), retract(movesMade(Moves)),
    asserta(movesMade(NewMoves)), updateBoard(Line, Column, 00, Board, NewBoard),
     makeUndo(NewBoard, NewBoard2, NewMoves))).

getUndo(Board, NewBoard2, Play, NewPlay2, _, 1):-
    (Play > 1,
    write('If you wish to undo this move, press U. If not, press any other button.'),nl,
    getChar(C),
    ((C == 'U',
    NewPlay is Play -1,
    movesMade(Moves),
    makeUndo(Board, NewBoard, Moves),
    printBoard(NewBoard), getUndo(NewBoard, NewBoard2, NewPlay, NewPlay2, 1)) ;
    (C \= 'U', NewBoard2 = Board, NewPlay2 = Play))) ; (NewBoard2 = Board, NewPlay2 = Play).

getUndo(Board, _, _, _, Repeat, 2):-
    write('If you wish to undo this move, press U. If not, press any other button.'),nl,
    getChar(C),
    ((C == 'U',
    movesMade(Moves),
    removeFirstElement(Moves, NewMoves),
    retract(movesMade(Moves)),
    asserta(movesMade(NewMoves)),
    printBoard(Board), Repeat is 1) ;
    (C \= 'U', Repeat is 0)).

% Implementation of the predicate that removes the first element of a List.

removeFirstElement([_|Tail], Tail).
