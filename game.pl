:- include('logic.pl').
:- include('board.pl').
:- include('utilities.pl').

% ##################### Menus ######################

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
  write('#                                 #'),nl,
  write('###################################'),nl,
  menu_option(2).

mode_menu_option(Op):- (Op < 1 ; Op > 3), nl, nl, write('WARNING!!! Please insert an option between 1 and 3!'),nl ,nl, menu_option(2).
mode_menu_option(1):- write('Ply Vs Ply').
mode_menu_option(2):- write('Ply Vs PC').
mode_menu_option(3):- write('PC Vs PC').

% MenuType : 1 -> Main Menu ; MenuType = 2 -> Mode Menu

menu_option(MenuType):-  write('Please insert your choice:'), nl,
  getDigit(Op),
  (
    (MenuType == 1, main_menu_option(Op));
    (MenuType == 2, mode_menu_option(Op))
  ).





play(Board):-
  /*  playWhite(X1,Y1,X2,Y2, getBoard())
    playBlack
    readPlayer(player),
    read*/
    readCoords(X1, Y1, X2, Y2),
    getElement(Board, Y1, X1, Element),
    write(Element),
    movePiece(X1, Y1, X2, Y2, Board, NewBoard).

readCoords(X1, Y1, X2, Y2):-
  read(X1),
  read(Y1),
  read(X2),
  read(Y2).



movePiece(X1, Y1, X2, Y2, Board, NewBoard):-
    ite(savePos(X1, Y1, Piece, Board), savePos(X1, Y1, Piece, Board), write(Piece)).
    /*writePos(X1, Y1, 00, Board, IntBoard),
    writePos(X2, Y2, Piece, IntBoard, NewBoard)*/

savePos(X, Y, Piece, Board):-
    ite(savePosLine(Y, Board, Line), savePosLine(Y, Board, Line), savePosCol(X, Piece, Line)).

not(X):- X, !, fail.
not(X).

savePosLine(Y, [Head|Tail], Line):-
        Y > 0,
        Y1 is Y-1,
        append(Head, [], Line),
        savePosLine(Y1, Tail, Line).

savePosCol(X, Piece, [Head|Tail]):-
    X > 0,
    X1 is X-1,
    Piece is Head,
    savePosCol(X1, Piece, Tail).

writePos(X1, Y1, Piece, Board, IntBoard):-
    writePosLine(Y, Board, IntBoard),
    writePosCol(X, Piece, Board, IntBoard).

writePosLine(Y, [Head|Tail], IntBoard):-
    Y > 0,
    Y is Y-1,

    writePosLine(Y, Tail, IntBoard).

writePosCol(X, Piece, [Head|Tail]):-
    X > 0,
    X is X-1,
    savePosLine(X, Head, Tail).

ite(If, Then, Else):- If, !, Then.

ite(_, _, Else):- Else.
