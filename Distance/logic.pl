% Solver
% Solves a puzzle
solver(EmptyBoard, SolvedBoard) :-
getBlanks(EmptyBoard, Blanks),
length(Blanks, NumBlanks),
length(Numbers, NumBlanks),
domain(Numbers, 1, NumBlanks),
all_distinct(Numbers),
constrainDistances(Blanks, NumBlanks, Numbers),
labeling(ff, Numbers),
fillBoard(Numbers, Blanks, EmptyBoard, SolvedBoard, NumBlanks),
printBoard(SolvedBoard).

% Receives a list of numbers and a list of the blank coords
% Updates the board accordingly
fillBoard(Numbers, Blanks, Board, NewBoard, 1):-
nth1(Index, Numbers, CoordsIndex),
nth1(CoordsIndex, Blanks, Line-Column),
updateBoard(Line, Column, Index, Board, NewBoard).
fillBoard(Numbers, Blanks, Board, NewBoard, Index) :-
Index1 is Index-1,
fillBoard(Numbers, Blanks, Board, NewBoard1, Index1),
nth1(Index, Numbers, CoordsIndex),
nth1(CoordsIndex, Blanks, Line-Column),
updateBoard(Line, Column, Index, NewBoard1, NewBoard).

% Constrains the distance between consecutive pairs
% The distance between pairs must increase as the numbers increase
constrainDistances(Blanks, NumBlanks, Numbers) :-
Number is NumBlanks-2,
constrainDistancesAux(Blanks, NumBlanks, Numbers, Number).

constrainDistancesAux(_Blanks, _NumBlanks, _Numbers, 0).
constrainDistancesAux(Blanks, NumBlanks, Numbers, Number) :-
Number1 is Number+1,
Number2 is Number+2,
nth1(Number, Numbers, CoordsIndex),
nth1(Number1, Numbers, CoordsIndex1),
nth1(Number2, Numbers, CoordsIndex2),
nth1(CoordsIndex, Blanks, Coords),
nth1(CoordsIndex1, Blanks, Coords1),
nth1(CoordsIndex2, Blanks, Coords2),
calcDist(Coords, Coords1, Dist1),
calcDist(Coords1, Coords2, Dist2),
Dist1 #< Dist2,
NumberAux is Number-1,
constrainDistancesAux(Blanks, NumBlanks, Numbers, NumberAux).


% Generator
% Generates a board with N ammount of blank spaces
% With max dimensions of N/2 + 1
generator(NumBlanks, Board, SolvedBoard) :-
MaxLen is integer(NumBlanks div 2) + 1,
length(Lines, NumBlanks),
length(Cols, NumBlanks),
domain(Lines, 1, MaxLen),
domain(Cols, 1, MaxLen),
constrainGenerator(NumBlanks, Lines, Cols),
labeling([value(getBoard(MaxLen))], Lines),
labeling([value(getBoard(MaxLen))], Cols),
generateBoard(Lines, Cols, NumBlanks, Board, SolvedBoard),
printBoard(SolvedBoard).

% Generates random coords in order to generate different boards everytime
getBoard(MaxLen, Var, _Rest, BB, BB0) :-
MaxLen1 is MaxLen+1,
random(1, MaxLen1, Value),
(first_bound(BB, BB0), Var #= Value;
later_bound(BB, BB0), Var #\= Value).

% Constrains the distance between consecutive pairs
% The distance between pairs must increase as the numbers increase
% In order to have more compact boards,
% The distance of a pair must be smaller than its largest number
% For example, the distance between 6 and 7 must be smaller than 7
constrainGenerator(NumBlanks, Lines, Cols) :-
Number is NumBlanks-2,
constrainGeneratorAux(Number, Lines, Cols, []).

constrainGeneratorAux(1, Lines, Cols, Coords) :-
element(1, Lines, Line),
element(2, Lines, Line1),
element(3, Lines, Line2),
element(1, Cols, Col),
element(2, Cols, Col1),
element(3, Cols, Col2),
calcDist(Line-Col, Line1-Col1, Dist1),
calcDist(Line1-Col1, Line2-Col2, Dist2),
Dist2 #< 9,
Dist1 #< Dist2,
AuxCoords2 #= Line2 * 10 + Col2,
NewCoords2 = [AuxCoords2|Coords],
AuxCoords1 #= Line1 * 10 + Col1,
NewCoords1 = [AuxCoords1|NewCoords2],
AuxCoords #= Line * 10 + Col,
NewCoords = [AuxCoords|NewCoords1],
all_distinct(NewCoords).
constrainGeneratorAux(Number, Lines, Cols, Coords) :-
Number1 is Number+1,
Number2 is Number+2,
element(Number, Lines, Line),
element(Number1, Lines, Line1),
element(Number2, Lines, Line2),
element(Number, Cols, Col),
element(Number1, Cols, Col1),
element(Number2, Cols, Col2),
calcDist(Line-Col, Line1-Col1, Dist1),
calcDist(Line1-Col1, Line2-Col2, Dist2),
Dist2 #< (Number+2 * Number+2),
Dist1 #< Dist2,
NumberAux is Number-1,
AuxCoords #= Line2 * 10 + Col2,
NewCoords = [AuxCoords|Coords],
constrainGeneratorAux(NumberAux, Lines, Cols, NewCoords).

% Generates an empty board and the respective solved board
generateBoard(Lines, Cols, NumBlanks, Board, SolvedBoard) :-
min_member(MinLine, Lines),
min_member(MinCol, Cols),
setMinToOne(Lines, NewLines, MinLine),
setMinToOne(Cols, NewCols, MinCol),
generateEmptyBoard(NewLines, NewCols, EmptyBoard),
fillBoardGenerator(NewLines, NewCols, NumBlanks, EmptyBoard, Board),
reverse(NewLines, LinesR),
reverse(NewCols, ColsR),
solveBoardGenerator(LinesR, ColsR, NumBlanks, EmptyBoard, SolvedBoard).

% Deletes possible empty lines/cols around the board
setMinToOne([], [], _Min).
setMinToOne([H|T], NewList, Min) :-
setMinToOne(T, AuxList, Min),
NH is H - Min + 1,
NewList = [NH|AuxList].

% Auxiliar function to fill the board
fillBoardGenerator([HL], [HC], 1, Board, NewBoard) :-
updateBoard(HL, HC, 0, Board, NewBoard).
fillBoardGenerator([HL|TL], [HC|TC], Index, Board, NewBoard) :-
Index1 is Index-1,
fillBoardGenerator(TL, TC, Index1, Board, AuxBoard),
updateBoard(HL, HC, 0, AuxBoard, NewBoard).

% Auxiliar function to fill the solved board
solveBoardGenerator([HL], [HC], 1, Board, NewBoard) :-
updateBoard(HL, HC, 1, Board, NewBoard).
solveBoardGenerator([HL|TL], [HC|TC], Index, Board, NewBoard) :-
Index1 is Index-1,
solveBoardGenerator(TL, TC, Index1, Board, AuxBoard),
updateBoard(HL, HC, Index, AuxBoard, NewBoard).

% Auxiliar function to generate a generic board with an ammount of lines and cols
% This is a board only filled with '@', to be used in other functions
generateEmptyBoard(Lines, Cols, Board) :-
max_member(NumLines, Lines),
max_member(NumCols, Cols),
generateEmptyBoardAux(NumLines, NumCols, Board).

generateEmptyBoardAux(0, _NumCols, []).
generateEmptyBoardAux(NumLines, NumCols, Board) :-
NumLines1 is NumLines-1,
generateEmptyBoardAux(NumLines1, NumCols, NewBoard),
generateEmptyLine(NumCols, NewLine),
Board = [NewLine|NewBoard].

generateEmptyLine(0, []).
generateEmptyLine(NumCols, NewLine) :-
NumCols1 is NumCols-1,
generateEmptyLine(NumCols1, AuxLine),
NewLine = ['@'|AuxLine].
