:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(sets)).


%Solver Stuff

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



%Generator Stuff

generator(NumBlanks, Board) :-
length(Coords, NumBlanks),
domain(Coords, 1, NumBlanks),
all_distinct(Coords),
constrainGenerator(NumBlanks, Coords),
labeling(ff, Coords),
write(Coords).


constrainGenerator(NumBlanks, Coords) :-
Number is NumBlanks-2,
constrainGeneratorAux(Coords, Number).


constrainGeneratorAux(Coords, 1) :-
element(1, Coords, Line-Col),
element(2, Coords, Line1-Col1),
element(3, Coords, Line2-Col2),
calcDist(Line-Col, Line1-Col1, Dist1),
calcDist(Line1-Col1, Line2-Col2, Dist2),
Dist1 #< Dist2,
Coords = [Line-Col, Line1-Col1, Line2-Col2].

constrainGeneratorAux(Coords, Number) :-
Number1 is Number+1,
Number2 is Number+2,
element(Number, Coords, Line),
element(Number1, Coords, Line1),
element(Number2, Coords, Line2),
calcDist(Line-Col, Line1-Col1, Dist1),
calcDist(Line1-Col1, Line2-Col2, Dist2),
Dist1 #< Dist2,
NewCoords = [Line-Col|Coords],
NumberAux is Number-1,
constrainGeneratorAux(NewCoords, NumberAux).
