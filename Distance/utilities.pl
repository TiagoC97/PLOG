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

isBlank(Board, Line, Col) :-
nth1(Line, Board, BoardLine),
nth1(Col, BoardLine, 0).

getBlanks(Board, Blanks) :-
setof(L-C, isBlank(Board, L, C), Blanks).

% Function used to calculate the square distance between to points in a 2D board

calcDist(L1-C1, L2-C2, Dist) :-
Dist #= (L1-L2) * (L1-L2) + (C1-C2) * (C1-C2).
%Dist #= integer(exp(L1-L2, 2) + exp(C1-C2, 2)).

% Functions used to update the puzzle board. Putting a given number in a given place

updateBoard(1, Column, Number, [FirstLine|OtherLines], [NewFirstLine|OtherLines]):-
updateBoardOneList(Column, Number, FirstLine, NewFirstLine).
updateBoard(Line, Column, Number, [FirstLine|OtherLines], [FirstLine|NewOtherLines]):-
Line > 1,
NewLine is Line-1,
updateBoard(NewLine, Column, Number, OtherLines, NewOtherLines).

updateBoardOneList(1, Number, [_|Tail], [Number|Tail]).
updateBoardOneList(Column, Number, [Head|Tail], [Head|NewTail]):-
Column > 1,
NewColumn is Column-1,
updateBoardOneList(NewColumn, Number, Tail, NewTail).
