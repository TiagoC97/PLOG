:- include('logic.pl').
:- include('board.pl').
:- include('utilities.pl').

:- dynamic modeGame/1.
:- dynamic(aiLevel/1).


% ##################### Menus ######################

% First predicate to be called in order to begin the menu display.
% It also resets the dynamic predicates of this file.
menu:-
    retractall(aiLevel(_)),
    retractall(modeGame(_)),
    asserta(aiLevel(1)),
    asserta(modeGame(1)),
    main_menu.

main_menu:- cls,
  write('###################################'),nl,
  write('############ Barragoon ############'),nl,
  write('###################################'),nl,
  write('#                                 #'),nl,
  write('#          1: PLAY                #'),nl,
  write('#          2: MODE                #'),nl,
  write('#          3: CHOOSE AI LEVEL     #'),nl,
  write('#          4: LEAVE               #'),nl,
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(1).

main_menu_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 4!'),nl ,nl, menu_option(1).
main_menu_option(1):- modeGame(MG), aiLevel(AI), not(startGame(MG, AI)), showStatistics.  % Starts the game
main_menu_option(2):- menu_mode.  % Opens the menu for the mode choice
main_menu_option(3):- menu_cpu_level.
main_menu_option(4):- halt. % Stops the program

menu_mode :- cls,
  write('###################################'),nl,
  write('############ Barragoon ############'),nl,
  write('###################################'),nl,
  write('#                                 #'),nl,
  write('#     1: PLAYER - PLAYER          #'),nl,
  write('#     2: PLAYER - CPU             #'),nl,
  write('#     3: CPU - CPU                #'),nl,
  write('#     4: BACK                     #'),nl,
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(2).

mode_menu_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 4!'),nl ,nl, menu_option(2).
mode_menu_option(1):- retractall(modeGame(_)), asserta(modeGame(1)) ,mode_menu_option(4).
mode_menu_option(2):- retractall(modeGame(_)), asserta(modeGame(2)) ,mode_menu_option(4).
mode_menu_option(3):- retractall(modeGame(_)), asserta(modeGame(3)) ,mode_menu_option(4).
mode_menu_option(4):- main_menu.

menu_cpu_level :- cls,
  write('######################################'),nl,
  write('############## Barragoon #############'),nl,
  write('######################################'),nl,
  write('#                                    #'),nl,
  write('#              1: EASY               #'),nl,
  write('#              2: MEDIUM             #'),nl,
  write('#              3: HARD               #'),nl,
  write('#              4: BACK               #'),nl,
  write('#                                    #'),nl,
  write('######################################'),nl,
  menu_option(3).

menu_cpu_level_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 4!'),nl ,nl, menu_option(3).
menu_cpu_level_option(1):- retractall(aiLevel(_)), asserta(aiLevel(1)), menu_cpu_level_option(4).
menu_cpu_level_option(2):- retractall(aiLevel(_)), asserta(aiLevel(2)), menu_cpu_level_option(4).
menu_cpu_level_option(3):- retractall(aiLevel(_)), asserta(aiLevel(3)), menu_cpu_level_option(4).
menu_cpu_level_option(4):- main_menu.

% MenuType : 1 -> Main Menu ; MenuType = 2 -> Mode Menu ; MenuType = 3 -> CPU Level Menu

menu_option(MenuType):-  write('Please insert your choice:'), nl,
  getDigit(Op),
  (
    (MenuType == 1, main_menu_option(Op));
    (MenuType == 2, mode_menu_option(Op));
    (MenuType == 3, menu_cpu_level_option(Op))
  ).
