:- include('logic.pl').
:- include('board.pl').
:- include('utilities.pl').

:- dynamic(modeGame/1).
:- dynamic(aiLevel/1).
:- dynamic(aiStarting/1).
:- dynamic(aiLevelDiferent/1).


% ##################### Menus ######################

% First predicate to be called in order to begin the menu display.
% It also resets the dynamic predicates of this file.
menu:-
  retractall(aiLevel(_)),
  retractall(modeGame(_)),
  asserta(aiLevel(1)),
  asserta(modeGame(1)),
  asserta(aiStarting(2)),
  asserta(aiLevelDiferent(1)),
  main_menu.

  main_menu:- cls,
  write('##############################################'),nl,
  write('################## Barragoon #################'),nl,
  write('##############################################'),nl,
  write('#                                            #'),nl,
  write('#          1: PLAY                           #'),nl,
  write('#          2: MODE                           #'),nl,
  write('#          3: CHOOSE AI LEVEL                #'),nl,
  write('#          4: CHOOSE AI DIFFERENT LEVELS     #'),nl,
  write('#          5: LEAVE                          #'),nl,
  write('#                                            #'),nl,
  write('##############################################'),nl,
  menu_option(1).

  main_menu_option(Op):- (Op < 1 ; Op > 5), nl, nl, write('WARNING!!! Please insert an option between 1 and 5!'),nl ,nl, menu_option(1).
  main_menu_option(1):- modeGame(MG), aiLevel(AI), aiStarting(AS), aiLevelDiferent(ALD), not(startGame(MG, AI, AS, ALD)), showStatistics.  % Starts the game
  main_menu_option(2):- menu_mode.  % Opens the menu for the mode choice
  main_menu_option(3):- menu_cpu_level, aiLevel(AI), retractall(aiLevelDiferent(_)), asserta(aiLevelDiferent(AI)), main_menu. % Opens the menu for the cpu level choice
  main_menu_option(4):- menu_cpu_level, menu_cpu_dif_level. % Opens the menu for the different cpu levels choice
  main_menu_option(5):- halt. % Stops the program

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

  mode_menu_option(Op):- (Op < 1 ; Op > 5), nl, nl, write('WARNING!!! Please insert an option between 1 and 5!'),nl ,nl, menu_option(2).
  mode_menu_option(1):- retractall(modeGame(_)), asserta(modeGame(1)), mode_menu_option(4).
  mode_menu_option(2):- retractall(modeGame(_)), asserta(modeGame(2)), mode_menu_option(5).
  mode_menu_option(3):- retractall(modeGame(_)), asserta(modeGame(3)), mode_menu_option(4).
  mode_menu_option(4):- main_menu.
  mode_menu_option(5):- mode_choose_starting.

  mode_choose_starting :- cls,
  write('###################################'),nl,
  write('############ Barragoon ############'),nl,
  write('###################################'),nl,
  write('#                                 #'),nl,
  write('#     1: PLAYER - WHITE           #'),nl,
  write('#     2: CPU - WHITE              #'),nl,
  write('#     3: BACK                     #'),nl,
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(3).

  mode_choose_starting_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(3).
  mode_choose_starting_option(1):- retractall(aiStarting(_)), asserta(aiStarting(2)) ,mode_choose_starting_option(3).
  mode_choose_starting_option(2):- retractall(aiStarting(_)), asserta(aiStarting(1)) ,mode_choose_starting_option(3).
  mode_choose_starting_option(3):- main_menu.

  menu_cpu_level :- cls,
  write('######################################'),nl,
  write('############## Barragoon #############'),nl,
  write('######################################'),nl,
  write('#                                    #'),nl,
  write('#              1: EASY               #'),nl,
  write('#              2: MEDIUM             #'),nl,
  write('#              3: HARD               #'),nl,
  write('#                                    #'),nl,
  write('######################################'),nl,
  menu_option(4).

  menu_cpu_level_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(4).
  menu_cpu_level_option(1):- retractall(aiLevel(_)), asserta(aiLevel(1)).
  menu_cpu_level_option(2):- retractall(aiLevel(_)), asserta(aiLevel(2)).
  menu_cpu_level_option(3):- retractall(aiLevel(_)), asserta(aiLevel(3)).

  menu_cpu_dif_level :- cls,
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
  menu_option(5).

  menu_cpu_dif_level_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 4!'),nl ,nl, menu_option(5).
  menu_cpu_dif_level_option(1):- retractall(aiLevelDiferent(_)), asserta(aiLevelDiferent(1)), menu_cpu_dif_level_option(4).
  menu_cpu_dif_level_option(2):- retractall(aiLevelDiferent(_)), asserta(aiLevelDiferent(2)), menu_cpu_dif_level_option(4).
  menu_cpu_dif_level_option(3):- retractall(aiLevelDiferent(_)), asserta(aiLevelDiferent(3)), menu_cpu_dif_level_option(4).
  menu_cpu_dif_level_option(4):- main_menu.

  % MenuType : 1 -> Main Menu ; MenuType = 2 -> Mode Menu ; MenuType = 3 -> CPU Starting menu ; MenuType = 4 -> CPU Level Menu

  menu_option(MenuType):-  write('Please insert your choice:'), nl,
  getDigit(Op),
  (
  (MenuType == 1, main_menu_option(Op));
  (MenuType == 2, mode_menu_option(Op));
  (MenuType == 3, mode_choose_starting_option(Op));
  (MenuType == 4, menu_cpu_level_option(Op));
  (MenuType == 5, menu_cpu_dif_level_option(Op))
  ).

x:-

    repeat,
      write('aa'),nl,
    !,
    getChar(X), ((X == 'U', fail) ; (X \= 'U')).

aux:-
    repeat,
      x,
    !.
