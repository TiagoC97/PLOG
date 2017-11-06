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
printCoordsX,
printBlackLine,
printRowByRow(Board, 1).

printCoordsX :-
nl,
write(' |'),
write('  1  '),
write('|'),
write('  2  '),
write('|'),
write('  3  '),
write('|'),
write('  4  '),
write('|'),
write('  5  '),
write('|'),
write('  6  '),
write('|'),
write('  7  '),
write('|'),
nl.

printBlackLine :-
write('--------------------------------------------'),
nl.

printRowByRow([], N).
printRowByRow([Line|Rest], N) :-
write(' |'),
printSingleRowFirst(Line),
write(N),
write('|'),
printSingleRowSecond(Line),
write(' |'),
printSingleRowThird(Line),
N1 is N+1,
printRowByRow(Rest, N1).

printSingleRowFirst([Cell]):-
translateCellFirst(Cell),
write('|'),
nl.

printSingleRowFirst([Cell|More]):-
translateCellFirst(Cell),
write('|'),
printSingleRowFirst(More).


printSingleRowSecond([Cell]):-
translateCellSecond(Cell),
write('|'),
nl.

printSingleRowSecond([Cell|More]):-
translateCellSecond(Cell),
write('|'),
printSingleRowSecond(More).


printSingleRowThird([Cell]):-
translateCellThird(Cell),
write('|'),
nl,
printBlackLine.

printSingleRowThird([Cell|More]):-
translateCellThird(Cell),
write('|'),
printSingleRowThird(More).


translateCellFirst(00) :-
write('     ').

translateCellFirst(12) :-
write('o    ').

translateCellFirst(13) :-
write('  o  ').

translateCellFirst(14) :-
write('o - o').

translateCellFirst(22) :-
write('*    ').

translateCellFirst(23) :-
write('* - *').

translateCellFirst(24) :-
write('* - *').

translateCellFirst(30) :-
write('x x x').

translateCellFirst(31) :-
write('^ ^ ^').

translateCellFirst(32) :-
write('---->').

translateCellFirst(33) :-
write('<----').

translateCellFirst(34) :-
write('| | |').

translateCellFirst(35) :-
write('^ ^ ^').

translateCellFirst(36) :-
write('<--->').

translateCellFirst(37) :-
write('  ^  ').

translateCellFirst(40) :-
write('+--->').

translateCellFirst(41) :-
write('----+').

translateCellFirst(42) :-
write('  | |').

translateCellFirst(43) :-
write('^ ^  ').

translateCellFirst(44) :-
write('<---+').

translateCellFirst(45) :-
write('+----').

translateCellFirst(46) :-
write('| |  ').

translateCellFirst(47) :-
write('  ^ ^').

translateCellFirst(Cell) :-
write(Cell).


translateCellSecond(12) :-
write('  \\  ').

translateCellSecond(13) :-
write(' / \\ ').

translateCellSecond(14) :-
write('|   |').

translateCellSecond(22) :-
write('  \\  ').

translateCellSecond(23) :-
write(' \\ / ').

translateCellSecond(24) :-
write('|   |').

translateCellSecond(31) :-
write('| | |').

translateCellSecond(34) :-
write('| | |').

translateCellSecond(35) :-
write('| | |').

translateCellSecond(37) :-
write('< + >').

translateCellSecond(40) :-
write('| +->').

translateCellSecond(41) :-
write('--+ |').

translateCellSecond(42) :-
write('<-+ |').

translateCellSecond(43) :-
write('| +--').

translateCellSecond(44) :-
write('<-+ |').

translateCellSecond(45) :-
write('| +--').

translateCellSecond(46) :-
write('| +->').

translateCellSecond(47) :-
write('--+ |').

translateCellSecond(Cell) :-
translateCellFirst(Cell).


translateCellThird(12) :-
write('    o').

translateCellThird(13) :-
write('o - o').

translateCellThird(22) :-
write('    *').

translateCellThird(23) :-
write('  *  ').

translateCellThird(31) :-
write('| | |').

translateCellThird(34) :-
write('v v v').

translateCellThird(35) :-
write('v v v').

translateCellThird(37) :-
write('  v  ').

translateCellThird(40) :-
write('| |  ').

translateCellThird(41) :-
write('  v v').

translateCellThird(42) :-
write('<---+').

translateCellThird(43) :-
write('+----').

translateCellThird(44) :-
write('  | |').

translateCellThird(45) :-
write('v v  ').

translateCellThird(46) :-
write('+--->').

translateCellThird(47) :-
write('----+').

translateCellThird(Cell) :-
translateCellFirst(Cell).
