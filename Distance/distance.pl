:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).
:- use_module(library(sets)).

:- include('board.pl').
:- include('utilities.pl').
:- include('logic.pl').

distance :- showMainMenu.

showMainMenu:- nl,nl,nl,nl,
write('##############################################'),nl,
write('################## DISTANCE ##################'),nl,
write('##############################################'),nl,
write('#                                            #'),nl,
write('#                1: SOLVER                   #'),nl,
write('#                2: GENERATOR                #'),nl,
write('#                3: LEAVE                    #'),nl,
write('#                                            #'),nl,
write('##############################################'),nl,
menu_option(1, _, _).

main_menu_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(1).
main_menu_option(1):- showSolverMenu.
main_menu_option(2):- generatorMenu.
main_menu_option(3).

showSolverMenu:- nl,nl,nl,nl,
write('##############################################'),nl,
write('################### SOLVER ###################'),nl,
write('##############################################'),nl,
write('#                                            #'),nl,
write('#              1: SMALL PUZZLE               #'),nl,
write('#              2: MEDIUM PUZZLE              #'),nl,
write('#              3: BIG PUZZLE                 #'),nl,
write('#              4: BACK                      #'),nl,
write('#                                            #'),nl,
write('##############################################'),nl,
menu_option(2, _, _).

solver_menu_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 4!'),nl ,nl, menu_option(2).
solver_menu_option(1):- emptyBoardSmall(Board), solver(Board, SolvedBoard), printBoard(SolvedBoard), showMainMenu.  % Opens the menu for the mode choice
solver_menu_option(2):- emptyBoardMedium(Board), solver(Board, SolvedBoard), printBoard(SolvedBoard), showMainMenu.  % Opens the menu for the mode choice
solver_menu_option(3):- emptyBoardBig(Board), solver(Board, SolvedBoard), printBoard(SolvedBoard), showMainMenu.  % Opens the menu for the mode choice
solver_menu_option(4):- showMainMenu.  % Opens the menu for the mode choice

generatorMenu:-
  write('Please give the number (two digits) of blank spaces (>= 3) for the new puzzle: '),
  getDoubleDigit(NumBlanks),
  (((NumBlanks > 2, NumBlanks < 100), generator(NumBlanks, Board, SolvedBoard), showGeneratorMenu(Board, SolvedBoard)) ; write('Number of blank spaces must be >= 3!'), nl, nl, generatorMenu).

showGeneratorMenu(Board, SolvedBoard):-
nl,nl,nl,nl,
write('##############################################'),nl,
write('################# Generator ##################'),nl,
write('##############################################'),nl,
write('#                                            #'),nl,
write('#              1: SHOW BOARD                 #'),nl,
write('#              2: SHOW SOLUTION              #'),nl,
write('#              3: BACK                       #'),nl,
write('#                                            #'),nl,
write('##############################################'),nl,
menu_option(3, Board, SolvedBoard).

generator_menu_option(Op, Board, SolvedBoard):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(3, Board, SolvedBoard).
generator_menu_option(1, Board, SolvedBoard):- printBoard(Board), showGeneratorMenu(Board, SolvedBoard).  % Opens the menu for the mode choice
generator_menu_option(2, Board, SolvedBoard):- printBoard(SolvedBoard), showGeneratorMenu(Board, SolvedBoard).  % Opens the menu for the mode choice
generator_menu_option(3, _, _):- showMainMenu.


menu_option(MenuType, Board, SolvedBoard):-  write('Please insert your choice:'), nl,
getDigit(Op),
(
  (MenuType == 1, main_menu_option(Op));
  (MenuType == 2, solver_menu_option(Op));
  (MenuType == 3, generator_menu_option(Op, Board, SolvedBoard))
  ).
