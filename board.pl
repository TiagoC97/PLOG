play(Board).

initialBoard([
[00, 24, 23, 00, 23, 24, 00],
[00, 00, 22, 23, 22, 00, 00],
[00, 00, 00, 00, 00, 00, 00],
[00, 30, 00, 00, 00, 30, 00],
[30, 00, 30, 00, 30, 00, 30],
[00, 30, 00, 00, 00, 30, 00],
[00, 00, 00, 00, 00, 00, 00],
[00, 00, 12, 13, 12, 00, 00],
[00, 14, 13, 00, 13, 14, 00]]).

printBoard(Board) :-
cls,
printBlackLine,
printRowByRow(Board).

printBlackLine :-
write('-----------------------------'),
nl.

printRowByRow([]).
printRowByRow([Line|Rest]) :-
write('|'),
printSingleRowInt(Line),
write('|'),
printSingleRow(Line),
printRowByRow(Rest).

printSingleRowInt([Cell]):-
translateCellInt(Cell),
write('|'),
nl.

printSingleRowInt([Cell|More]):-
translateCellInt(Cell),
write('|'),
printSingleRowInt(More).


printSingleRow([Cell]):-
translateCell(Cell),
write('|'),
nl,
printBlackLine.


printSingleRow([Cell|More]):-
translateCell(Cell),
write('|'),
printSingleRow(More).


translateCellInt(00) :-
write('   ').

translateCellInt(12) :-
write('o  ').

translateCellInt(13) :-
write(' o ').

translateCellInt(14) :-
write('o o').

translateCellInt(22) :-
write('+  ').

translateCellInt(23) :-
write('+ +').

translateCellInt(24) :-
write('+ +').

translateCellInt(30) :-
write('x x').

translateCellInt(31) :-
put_code(8593),
write(' '),
put_code(8593).

translateCellInt(32) :-
put_code(8594),
write(' '),
put_code(8594).

translateCellInt(33) :-
put_code(8595),
write(' '),
put_code(8595).

translateCellInt(34) :-
put_code(8592),
write(' '),
put_code(8592).

translateCellInt(35) :-
put_code(8597),
write(' '),
put_code(8597).

translateCellInt(36) :-
put_code(8596),
write(' '),
put_code(8596).

translateCellInt(37) :-
write('xxx').

translateCellInt(40) :-
put_code(8625),
write(' '),
put_code(8625).

translateCellInt(41) :-
put_code(11022),
write(' '),
put_code(11022).

translateCellInt(42) :-
put_code(8594),
write(' '),
put_code(8594).

translateCellInt(43) :-
put_code(8595),
write(' '),
put_code(8595).

translateCellInt(44) :-
put_code(8592),
write(' '),
put_code(8592).

translateCellInt(45) :-
put_code(8597),
write(' '),
put_code(8597).

translateCellInt(46) :-
put_code(8596),
write(' '),
put_code(8596).

translateCellInt(47) :-
write('xxx').

translateCellInt(Cell) :-
write(Cell).


translateCell(12) :-
write('  o').

translateCell(13) :-
write('o o').

translateCell(22) :-
write('  +').

translateCell(23) :-
write(' + ').

translateCell(31) :-
put_code(8593),
write(' '),
put_code(8593).

translateCell(32) :-
put_code(8594),
write(' '),
put_code(8594).

translateCell(33) :-
put_code(8595),
write(' '),
put_code(8595).

translateCell(34) :-
put_code(8592),
write(' '),
put_code(8592).

translateCell(35) :-
put_code(8597),
write(' '),
put_code(8597).

translateCell(36) :-
put_code(8596),
write(' '),
put_code(8596).

translateCell(37) :-
write('xxx').

translateCell(40) :-
put_code(8625),
write(' '),
put_code(8625).

translateCell(41) :-
put_code(11022),
write(' '),
put_code(11022).

translateCell(42) :-
put_code(8594),
write(' '),
put_code(8594).

translateCell(43) :-
put_code(8595),
write(' '),
put_code(8595).

translateCell(44) :-
put_code(8592),
write(' '),
put_code(8592).

translateCell(45) :-
put_code(8597),
write(' '),
put_code(8597).

translateCell(46) :-
put_code(8596),
write(' '),
put_code(8596).

translateCell(47) :-
write('xxx').

translateCell(Cell) :-
translateCellInt(Cell).

/*
movePiece(X1, Y1, X2, Y2, _Board) :-
read(X1 - Y1),
read(X2 - Y2).
*/
