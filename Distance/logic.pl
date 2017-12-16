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
write(Numbers).


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
