:- use_module(library(lists)).

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

ite(If, Then, Else):- If, !, Then.
ite(_, _, Else):- Else.

% Determine if a given Play is even or odd
even(Play):- Play mod 2 =:= 0.

odd(Play):- Play mod 2 =:= 1.

getPiece(Board, Line, Col, Piece):-
    nth1(Line, Board, BoardLine),
    nth1(Col, BoardLine, Piece).

checkLine(Line):-
  (Line >= 1, Line =< 9);
  nl, write('WARNING! Line must be between 1 and 9!'), nl, nl, !, fail.

checkColumn(Column):-
  (Column >= 1, Column =< 7);
  nl, write('WARNING! Column must be between 1 and 7!'), nl, nl, !, fail.

checkBarragoonFace(Face):-
  ((Face >= 30, Face =< 37) ; (Face >= 40, Face =< 47)) ;
  nl, write('WARNING! Please insert a valid barragoon face!'), nl, nl, !, fail.

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
