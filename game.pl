:- include('logic.pl').
:- include('board.pl').
:- include('utilities.pl').

:- dynamic modeGame/1.
:- dynamic(aiLevel/1).


% ##################### Menus ######################

menu:-
    asserta(aiLevel(0)),
    asserta(modeGame(0)),
    main_menu.

main_menu:- cls,
  write('###################################'),nl,
  write('############ Barragoon ############'),nl,
  write('###################################'),nl,
  write('#                                 #'),nl,
  write('#            1: PLAY              #'),nl,
  write('#            2: MODE              #'),nl,
  write('#            3: LEAVE             #'),nl,
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(1).

main_menu_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(1).
main_menu_option(1):- startGame.  % Starts the game
main_menu_option(2):- menu_mode.  % Opens the menu for the mode choice
main_menu_option(3):- halt. % Stops the program

menu_mode :- cls,
  write('###################################'),nl,
  write('############ Barragoon ############'),nl,
  write('###################################'),nl,
  write('#                                 #'),nl,
  write('#     1: PLAYER - PLAYER          #'),nl,
  write('#     2: PLAYER - CPU             #'),nl,
  write('#     3: CPU - CPU                #'),nl,
  write('#     4: CHOOSE AI LEVEL          #'),nl,
  write('#     5: BACK                     #'),nl,
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(2).

mode_menu_option(Op):- (Op < 1 ; Op > 5), nl, nl, write('WARNING!!! Please insert an option between 1 and 5!'),nl ,nl, menu_option(2).
mode_menu_option(1):- retractall(modeGame(_)), asserta(modeGame(1)) ,mode_menu_option(5).
mode_menu_option(2):- retractall(modeGame(_)), asserta(modeGame(2)) ,mode_menu_option(5).
mode_menu_option(3):- retractall(modeGame(_)), asserta(modeGame(3)) ,mode_menu_option(5).
mode_menu_option(4):- menu_cpu_level.
mode_menu_option(5):- main_menu.

menu_cpu_level :- cls,
  write('######################################'),nl,
  write('############## Barragoon #############'),nl,
  write('######################################'),nl,
  write('#                                    #'),nl,
  write('#     1: COMPLETLY RANDOM            #'),nl,
  write('#     2: MOVES INTELLIGENTLY         #'),nl,
  write('#        BUT BARRAGOON PLACEMENT DUM #'),nl,
  write('#     3: MOST SMART                  #'),nl,
  write('#     4: BACK                        #'),nl,
  write('#                                    #'),nl,
  write('######################################'),nl,
  menu_option(3).

menu_cpu_level_option(Op):- (Op < 1 ; Op > 4), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(3).
menu_cpu_level_option(1):- retractall(aiLevel(_)), asserta(aiLevel(1)), menu_cpu_level_option(4).
menu_cpu_level_option(2):- retractall(aiLevel(_)), asserta(aiLevel(2)), menu_cpu_level_option(4).
menu_cpu_level_option(3):- retractall(aiLevel(_)), asserta(aiLevel(3)), menu_cpu_level_option(4).
menu_cpu_level_option(4):- menu_mode.

% MenuType : 1 -> Main Menu ; MenuType = 2 -> Mode Menu

menu_option(MenuType):-  write('Please insert your choice:'), nl,
  getDigit(Op),
  (
    (MenuType == 1, main_menu_option(Op));
    (MenuType == 2, mode_menu_option(Op));
    (MenuType == 3, menu_cpu_level_option(Op))
  ).
