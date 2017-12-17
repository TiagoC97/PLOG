% Creates the initial board

initialBoard([
[@, 3, 5, @],
[@, @, 2, @],
[6, 4, 1, 7]]).

emptyBoard([
[@, 0, 0, @],
[@, @, 0, @],
[0, 0, 0, 0]]).

emptyBoardRip([
[0, 0],
[0, 0]]).

emptyBoardBig([
[@, @, @, @, 0, 0, 0, 0],
[0, @, 0, @, 0, @, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0]]).

% Prints the board

printBoard([Line|Rest]) :-
length(Line, Cols),
printBlackLine(Cols),
printWhiteLine(Cols),
printRowByRow([Line|Rest]),
printBlackLine(Cols).


printBlackLine(Cols) :-
write('+--'),
printBlackLineAux(Cols),
write('+'),
nl.

printBlackLineAux(0).

printBlackLineAux(Cols) :-
write('---------'),
Cols1 is Cols - 1,
printBlackLineAux(Cols1).


printWhiteLine(Cols) :-
write('|  '),
printWhiteLineAux(Cols),
write('|'),
nl.

printWhiteLineAux(0).

printWhiteLineAux(Cols) :-
write('         '),
Cols1 is Cols - 1,
printWhiteLineAux(Cols1).



printRowByRow([]).
printRowByRow([Line|Rest]) :-
write('|  '),
printSingleRowFirst(Line),
write('|  '),
printSingleRowSecond(Line),
write('|  '),
printSingleRowThird(Line),
write('|  '),
printSingleRowFourth(Line),
write('|  '),
printSingleRowFifth(Line),
length(Line, Cols),
printWhiteLine(Cols),
printRowByRow(Rest).

printSingleRowFirst([Cell]):-
translateCellFirst(Cell),
write('  |'),
nl.

printSingleRowFirst([Cell|More]):-
translateCellFirst(Cell),
write('  '),
printSingleRowFirst(More).

printSingleRowSecond([Cell]):-
translateCellSecond(Cell),
write('  |'),
nl.

printSingleRowSecond([Cell|More]):-
translateCellSecond(Cell),
write('  '),
printSingleRowSecond(More).

printSingleRowThird([Cell]):-
translateCellThird(Cell),
write('  |'),
nl.

printSingleRowThird([Cell|More]):-
translateCellThird(Cell),
write('  '),
printSingleRowThird(More).

printSingleRowFourth([Cell]):-
translateCellFourth(Cell),
write('  |'),
nl.

printSingleRowFourth([Cell|More]):-
translateCellFourth(Cell),
write('  '),
printSingleRowFourth(More).

printSingleRowFifth([Cell]):-
translateCellFifth(Cell),
write('  |'),
nl.

printSingleRowFifth([Cell|More]):-
translateCellFifth(Cell),
write('  '),
printSingleRowFifth(More).


translateCellFirst(@) :-
write('       ').

translateCellFirst(_) :-
write('+-----+').


translateCellSecond(@) :-
write('       ').

translateCellSecond(_) :-
write('|     |').


translateCellThird(@) :-
write('       ').

translateCellThird(Cell) :-
write('| '),
((Cell < 10, write('00'));
(Cell >= 10, Cell < 100, write('0'));
(Cell >= 100)),
write(Cell),
write(' |').


translateCellFourth(@) :-
write('       ').

translateCellFourth(_) :-
write('|     |').



translateCellFifth(@) :-
write('       ').

translateCellFifth(_) :-
write('+-----+').
