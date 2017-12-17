:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(sets)).

solver(EmptyBoard, SolvedBoard) :-
getBlanks(EmptyBoard, Blanks),
length(Blanks, NumBlanks),
length(Numbers, NumBlanks),
domain(Numbers, 1, NumBlanks),
all_distinct(Numbers),
constrainDistances(Blanks, NumBlanks, Numbers),
labeling(ff, Numbers),
fillBoard(Numbers, Blanks, EmptyBoard, SolvedBoard, EmptyBoard, NumBlanks),
printBoard(SolvedBoard).

fillBoard(Numbers, Blanks, Board, NewBoard, AuxBoard, 1):-
  nth1(Index, Numbers, CoordsIndex),
  nth1(CoordsIndex, Blanks, Line-Column),
  updateBoard(Line, Column, Index, AuxBoard, NewBoard).

fillBoard(Numbers, Blanks, Board, NewBoard, AuxBoard, Index) :-
Index1 is Index-1,
fillBoard(Numbers, Blanks, NewBoard, NewBoard1, AuxBoard, Index1),
nth1(Index, Numbers, CoordsIndex),
nth1(CoordsIndex, Blanks, Line-Column),
updateBoard(Line, Column, Index, NewBoard1, NewBoard).


displayAux(_Numbers, _Blanks, 8).

displayAux(Numbers, Blanks, N) :-
nth1(N, Numbers, CoordsIndex),
nth1(CoordsIndex, Blanks, Coords),
write(Coords),
write(', '),
N1 is N+1,
displayAux(Numbers, Blanks, N1).



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
