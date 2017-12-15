:- include('board.pl').
:- include('utilities.pl').

distance :- showMainMenu.

showMainMenu:- cls,
  write('##############################################'),nl,
  write('################### DISTANCE #################'),nl,
  write('##############################################'),nl,
  write('#                                            #'),nl,
  write('#                  1: SOLVER                 #'),nl,
  write('#                  2: GENERATOR              #'),nl,
  write('#                  3: LEAVE                  #'),nl,
  write('#                                            #'),nl,
  write('##############################################'),nl,
  menu_option(1).

  main_menu_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(1).
  main_menu_option(1):- menu_solver.  % Opens the menu for the mode choice
  main_menu_option(2):- menu_generator.  % Opens the menu for the mode choice
  main_menu_option(3):- halt.  % Opens the menu for the mode choice

  menu_option(MenuType):-  write('Please insert your choice:'), nl,
  getDigit(Op),
  (
  (MenuType == 1, main_menu_option(Op));
  (MenuType == 2, menu_solver_option(Op));
  (MenuType == 3, menu_generator_option(Op))
  ).
