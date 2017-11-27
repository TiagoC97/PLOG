:- dynamic(play_number/1).
:- dynamic(player/1).
:- dynamic(whiteCounter/1).
:- dynamic(brownCounter/1).
:- dynamic(movesMade/1).

% Predicate that initiates the game.
% It is responsible for making reset of all the dynamic predicates in this file,
% as well as for beggining the play cycle.
% The Mode represents: 1-> Player vs Player ; 2 -> Player vs CPU ; 3 -> CPU vs CPU
% The AiLevel represents: 1 -> Easy ; 2-> Medium ; 3 -> Hard
% The AiStarting represents: 1 -> CPU White ; 2-> Player White, when playing Human vs CPU
% The AiSecondLevel represents: 1 -> Easy ; 2-> Medium ; 3 -> Hard, for the other CPU (in mode CPU vs CPU)

startGame(Mode, AiLevel, AiStarting, AiSecondLevel) :-
  initialBoard(Board),
  retractall(play_number(_)),
  retractall(player(_)),
  retractall(whiteCounter(_)),
  retractall(brownCounter(_)),
  retractall(movesMade(_)),
  asserta(play_number(1)),
  ((AiStarting == 2, asserta(player(1))) ; (AiStarting == 1, asserta(player(2)))),
  asserta(whiteCounter(7)),
  asserta(brownCounter(7)),
  asserta(movesMade([])),
  play_cicle(Board, Mode, AiLevel, AiSecondLevel, AiStarting).

% Predicate that shows the game statistics

showStatistics:-
    movesMade(Moves),
    write(Moves),nl,
    play_number(Plays),
    whiteCounter(WC), brownCounter(BC),
    nl, write('Number of plays: '), write(Plays),nl,
    write('Number of white pieces left: '), write(WC), nl,
    write('Number of brown pieces left: '), write(BC), nl,
    (((WC == 0 ; BC == 0), write('Game won by eating all of the opponent pieces!'),nl) ;
     write('Game won by lack of valid moves for the opponent!'),nl).

% Predicate that cycles throw every play,
% printing the board, verifying if the as reached an end game state,
% making the play, updating the player and the play number.

play_cicle(Board, Mode, AiLevel, AiSecondLevel, AiStarting):-
  ((play_number(Play), Play == 1, printBoard(Board), nl,
  !) ; true),
  verifyEndGame(Board),
  !,
  play(Board, NewBoard, Mode, AiLevel, AiSecondLevel, AiStarting),
  !,
  nextPlayer(_),
  nextPlay(_),
  play_cicle(NewBoard, Mode, AiLevel, AiSecondLevel, AiStarting).

% Predicate used for game end verification.
% First it checks if any of the players has any pieces left, if so, the game continues,
% otherwise the game ends. Then it gets each player valid moves and checks if
% any of those is empty, if not, the game continues, otherwise the game ends.

verifyEndGame(Board):-
  (((whiteCounter(WC), (WC == 0),!, nl, write('Brown won'), nl, nl) ;
  (brownCounter(BC), (BC == 0),!, nl, write('White won'), nl, nl)),
  !,fail);
  player(P),
  ((P==1, P1 is 2); (P==2, P1 is 1)),
  (getValidMoves(Board, ValidMovesPlayer, P) ; true),
  length(ValidMovesPlayer, NumValidMovesPl),
  (getValidMoves(Board, ValidMovesOp, P1) ; true),
  length(ValidMovesOp, NumValidMovesOp),
  (((NumValidMovesPl == 0 ; NumValidMovesOp == 0),
  ((P == 1, ((NumValidMovesPl == 0, nl, write('Brown won')) ;
  (NumValidMovesOp == 0, nl, write('White won'))), nl, nl) ;
  (P == 2, ((NumValidMovesPl == 0, nl, write('White won')) ;
  (NumValidMovesOp == 0, nl, write('Brown won'))), nl, nl)), !, fail) ; true).

% Predicate that updates the player

nextPlayer(_):-
  player(P),
  ((P == 1, asserta(player(2)), retract(player(P))) ;
   (P == 2, asserta(player(1)), retract(player(P)))).

% Predicate that updates the play number

nextPlay(_):-
  play_number(P),
  P1 is P + 1,
  asserta(play_number(P1)),
  retract(play_number(P)).

% Predicate that makes the play in case the game mode is 1 (Player vs Player)
% It calls the predicate get_play and move

play(Board, NewBoard2, 1, _, _, _):-
  play_number(Play),
  getUndo(Board, NewBoard, Play, NewPlay, _, 1),

  ((NewPlay \= Play,
  retract(play_number(Play)),
  asserta(play_number(NewPlay)),
  ModPlay is mod(NewPlay, 2),
  player(P),
  ((ModPlay == 1, P == 2, retract(player(P)), asserta(player(1))) ; ((ModPlay == 0, P == 1, retract(player(P)), asserta(player(2)))))) ; true),

  repeat,
    get_play(NewBoard, Line, Column, NewLine, NewColumn),
  !,
  move(NewBoard, NewBoard2, Line, Column, NewLine, NewColumn, 1, _, _).

% Predicate that makes the play in case the game mode is 2 (Player vs CPU)
% It calls the predicate get_play in case the current player is 1
% and getAiPlay in case the current player is 2.
% It also calls the move predicate.

a(X):-
    X is mod(7+1, 2).

play(Board, NewBoard2, 2, AiLevel, _, AiStarting):-
  player(P1),

  play_number(Play),
  getUndo(Board, NewBoard, Play, NewPlay, _, 1),

  ((NewPlay \= Play,
  retract(play_number(Play)),
  asserta(play_number(NewPlay)),
  ModPlay2 is mod(NewPlay, 2),
  ((AiStarting == 1, ModPlay is mod(ModPlay2 + 1, 2)) ; ModPlay is ModPlay2),
  ((ModPlay == 1, retract(player(P1)), asserta(player(1))) ; ((ModPlay == 0, retract(player(P1)), asserta(player(2)))))) ; true),

  player(P),
  (
    (
      (P == 1),
      repeat,
        get_play(NewBoard, Line, Column, NewLine, NewColumn),
      !
    ) ;
    (
      (P == 2),

      getAiPlay(NewBoard, Line, Column, NewLine, NewColumn, AiLevel),
      write('Column of the piece to move: '), write(Column), nl,
      write('Line of the piece to move: '), write(Line), nl,
      write('Column of the new place for the piece to move: '), write(NewColumn), nl,
      write('Line of the new place for the piece to move: '), write(NewLine), nl,nl,
      write('Press any key to continue: '), getChar(_), nl
    )
  ),
  !,
  move(NewBoard, NewBoard2, Line, Column, NewLine, NewColumn, 2, AiLevel, _).

% Predicate that makes the play in case the game mode is 3 (CPU vs CPU)
% It calls the predicates getAiPlay and move.

play(Board, NewBoard, 3, AiLevel, AiSecondLevel, _):-
    player(P),
    ((P == 1,
    getAiPlay(Board, Line, Column, NewLine, NewColumn, AiLevel),
        write('Column of the piece to move: '), write(Column), nl,
        write('Line of the piece to move: '), write(Line), nl,
        write('Column of the new place for the piece to move: '), write(NewColumn), nl,
        write('Line of the new place for the piece to move: '), write(NewLine), nl,nl,
        write('Press any key to continue: '), getChar(_), nl,
    !,
    move(Board, NewBoard, Line, Column, NewLine, NewColumn, 3, AiLevel, AiSecondLevel)) ;
    (P == 2,
    getAiPlay(Board, Line, Column, NewLine, NewColumn, AiSecondLevel),
        write('Column of the piece to move: '), write(Column), nl,
        write('Line of the piece to move: '), write(Line), nl,
        write('Column of the new place for the piece to move: '), write(NewColumn), nl,
        write('Line of the new place for the piece to move: '), write(NewLine), nl,nl,
        write('Press any key to continue: '), getChar(_), nl,
    !,
    move(Board, NewBoard, Line, Column, NewLine, NewColumn, 3, AiLevel, AiSecondLevel))).

% Predicate that shows in the screen which player turn is it.
% Then it asks for the player piece coordinates
% and then it asks for the new coordinates to move the piece to.

get_play(Board, Line, Column, NewLine, NewColumn):-
  tellPlayerToPlay(_),
  repeat,
    getPieceCurCoords(Column, Line),
    checkPieceFromCurrentPlayer(Board, Line, Column),
  !,
  repeat,
    getPieceNewCoords(NewColumn, NewLine),
    player(P),
    validateMove(Board, Line, Column, NewLine, NewColumn, P),
  !.

% Predicate that is called when the AiLevel is 1 and starts with showing in the screen
% which player turn is it.
% Then gets the player valid moves, checks if there is more than one and if there is,
% it creates a random number between 1 and the number of valid moves, getting the
% correspondent piece coordinates and new coordinates to move it to.
% If there is only ine valid move, it gets the coordinates from that.

getAiPlay(Board, Line, Column, NewLine, NewColumn, 1):-
  tellPlayerToPlay(_),
  player(P),
  (getValidMoves(Board, ValidMoves, P) ; true),
  length(ValidMoves, NumValidMoves),
  ((NumValidMoves == 1, PosValidMoves is NumValidMoves);
  (NumValidMoves =\= 1, random(1, NumValidMoves, PosValidMoves))),
  nth1(PosValidMoves, ValidMoves, Move),
  nth1(1, Move, NewPlace),
  nth1(2, Move, Piece),
  nth1(1, Piece, Line),
  nth1(2, Piece, Column),
  nth1(1, NewPlace, NewLine),
  nth1(2, NewPlace, NewColumn).

% Predicate that is called when the AiLevel is 2 or 3 and starts with showing in the screen
% which player turn is it.
% Then gets the player valued valid moves, checks if there is more than one and if there is,
% it then checks if the most valuable play has a value equal to 0 and if it does,
% it creates a random number between 1 and the number of valid moves, getting the
% correspondent piece coordinates and new coordinates to move it to.
% If the most valuable play has a value greater than 0, then this will be the chosen move.
% If there is only ine valid move, it gets the coordinates from that.

getAiPlay(Board, Line, Column, NewLine, NewColumn, _):-
    tellPlayerToPlay(_),
    player(P),
    getValuedValidMoves(Board, ValidMoves, P),
    length(ValidMoves, NumValidMoves),
    ((NumValidMoves == 1, nth1(NumValidMoves, ValidMoves, Move));
    nth1(NumValidMoves, ValidMoves, MoveCheck),
    nth1(1, MoveCheck, NewPlaceCheck),
    nth1(1, NewPlaceCheck, Value),
    ((Value == 0,
      random(1, NumValidMoves, RandomMoveNum),
      nth1(RandomMoveNum, ValidMoves, Move));
      nth1(NumValidMoves, ValidMoves, Move)
    )),
    nth1(1, Move, NewPlace),
    nth1(1, Move, NewPlace),
    nth1(1, NewPlace, Value),
    nth1(2, Move, Piece),
    nth1(1, Piece, Line),
    nth1(2, Piece, Column),
    nth1(2, NewPlace, NewLine),
    nth1(3, NewPlace, NewColumn).

% Predicate that applies the move of the selected piece to the new position, putting 00 in the original coordinates
% and the Piece in the new coordinates. It also verifies whether the new coordinates had a piece there,
% If not, the predicate returns true.
% If they had, the board, after the moves, is printed and it is called a predicate to check the type of piece it was.

move(Board, NewBoard3, Line, Column, NewLine, NewColumn, Mode, AiLevel, AiSecondLevel):-
  getPiece(Board, Line, Column, Piece),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  updateBoard(Line, Column, 00, Board, NewBoard),
  updateBoard(NewLine, NewColumn, Piece, NewBoard, NewBoard2),
  printBoard(NewBoard2),
  (((NewPiece =\= 00), !, verifyTypeNewPiece(Line, Column, Piece, NewLine, NewColumn, NewPiece, NewBoard2, NewBoard3, Mode, AiLevel, AiSecondLevel));
   (addMadeMove(0, Line, Column, Piece, NewLine, NewColumn, NewPiece), NewBoard3 = NewBoard2)).

% Predicate to check the type of piece that was on the new coordinates.
% It first verifies if it was a Barragoon and then checks if the game ends with this move. If not, the predicate captureBarragoon is called.
% If the piece was not a Barragoon, the it was an opponent piece.
% It checks who is the current player, and subtracts one to the number of the opponent pieces.
% Then it checks if the game ends with this move. If not, the predicate captureOponentPiece is called.

verifyTypeNewPiece(Line, Column, Piece, NewLine, NewColumn, NewPiece, Board, NewBoard, Mode, AiLevel, AiSecondLevel):-
  player(P),
  (((((NewPiece >= 30) , (NewPiece =< 37)) ; ((NewPiece >= 40) , (NewPiece =< 47))), addMadeMove(0, Line, Column, Piece, NewLine, NewColumn, NewPiece),
  !, verifyEndGame(Board),
  ((Mode == 3, ((P == 1, captureBarragoon(Board, NewBoard, Mode, AiLevel)) ; (P == 2, captureBarragoon(Board, NewBoard, Mode, AiSecondLevel))));
   repeat,
    captureBarragoon(Board, NewBoard, Mode, AiLevel),
   !)) ;
  (((P == 1, brownCounter(BC), BC1 is BC - 1, asserta(brownCounter(BC1)), retract(brownCounter(BC)), addMadeMove(1, Line, Column, Piece, NewLine, NewColumn, NewPiece)) ;
  (P == 2, whiteCounter(WC), WC1 is WC - 1, asserta(whiteCounter(WC1)), retract(whiteCounter(WC)), addMadeMove(2, Line, Column, Piece, NewLine, NewColumn, NewPiece))),
  !, verifyEndGame(Board), !, captureOponentPiece(Board, NewBoard, Mode, AiLevel, AiSecondLevel))).

% Predicate that is called when Mode is 1 (Player vs Player)
% It asks the current player for the coordinates to place the Barragoon.
% Then it asks the player for the face of the Barragoon.
% After validating the coordinates and that the selected place is empty,
% it is made an update board to place the Barragoon in the desired place.

captureBarragoon(Board, NewBoard, 1, _):-
    repeat,
      getBarragoonCoords(Column, Line, BarragoonFace),
      getPiece(Board, Line, Column, Piece),
      ((Piece == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail),
    !,
    addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
    updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
    printBoard(NewBoard), nl,
    ((getUndo(Board, _, _, _, Repeat, 2), ((Repeat == 1, !, fail) ; true)) ; true).

% Predicate that is called when Mode is 2 (Player vs CPU).
% If the current player is Human, it asks him for the coordinates and face of the Barragoon to place, validating the coordinates and that the selected place is empty.
% If the current player is the CPU, the AiLevel is checked. If the AiLevel is 1 or 2, a random Barragoon place and face is selected.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the player 1 valid moves,  to get a smart placement for the Barragoon.
% After that, update board is called to place the Barragoon in the desired place.

captureBarragoon(Board, NewBoard, 2, AiLevel):-
  player(P),
  ((P == 1,
    repeat,
      nl, write('White place your barragoon piece'), nl,
      getBarragoonCoords(Column, Line, BarragoonFace),
      getPiece(Board, Line, Column, Piece),
      ((Piece == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail),
    !) ;
    (P == 2,
    (((AiLevel == 1 ; AiLevel == 2),
    getRandomBarragoonPiece(Board, Line, Column, BarragoonFace));
    (AiLevel == 3, getValuedValidMoves(Board, ValidMoves, 1), getBarragoonPieceSmartBot(Board, ValidMoves, Line, Column, BarragoonFace))),
    nl, write('Brown place your barragoon piece'), nl,
    nl, write('Column of the place for the barragoon: '), write(Column), nl,
    write('Line of the place for the barragoon: '), write(Line), nl, nl,
    write('Press any key to continue: '), getChar(_), nl)),
  addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
  printBoard(NewBoard), nl, !,
  ((P == 1, getUndo(Board, _, _, _, Repeat, 2), ((Repeat == 1, !, fail) ; true)) ; (P == 2, true)).

% Predicate that is called when Mode is 3 (CPU vs CPU).
% First the AiLevel is checked. If the AiLevel is 1 or 2, a random Barragoon place and face is selected.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the opponent valid moves, to get a smart placement for the Barragoon.
% After that, update board is called to place the Barragoon in the desired place.

captureBarragoon(Board, NewBoard, 3, AiLevel):-
    (player(P), ((P == 1, P1 is 2) ; (P == 2, P1 is 1))),
    (((AiLevel == 1 ; AiLevel == 2), getRandomBarragoonPiece(Board, Line, Column, BarragoonFace)) ;
      (AiLevel == 3, getValuedValidMoves(Board, ValidMoves, P1), getBarragoonPieceSmartBot(Board, ValidMoves, Line, Column, BarragoonFace))),
      ((P == 1, nl, write('White place your barragoon piece'), nl) ;
      (P == 2, nl, write('Brown place your barragoon piece'), nl)),
      nl,write('Column of the place for the barragoon: '), write(Column), nl,
      write('Line of the place for the barragoon: '), write(Line), nl, nl,
      write('Press any key to continue: '), getChar(_), nl,
    addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
    updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
    printBoard(NewBoard), !.

% Predicate that is called by the captureOponentPiece predicate, when the Mode is 1 (Player vs Player).
% First it asks the current player for the coordinates and face of the Barragoon to place, validating the coordinates and that the selected place is empty.
% Then it updates the board, to place the Barragoon.
% Then it also asks the opponent for the coordinates and face of the Barragoon to place, validating the coordinates and that the selected place is empty.
% Then it makes the update board again to place the new Barragoon.
% It also displays the option of undoing the barragoon placement, as well as adding that to the list of made moves.

captureOponentPieceAux(P, Board, NewBoard, _, _, 1):-
  repeat,
  ((P == 1, nl, nl, write('Brown place your barragoon piece'), nl) ;
  (P == 2, nl, nl, write('White place your barragoon piece'), nl)),
  getBarragoonCoords(Column, Line, BarragoonFace),
  getPiece(Board, Line, Column, Piece),
  ((Piece == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail),
  !,
  addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
  printBoard(NewBoard),
  ((getUndo(Board, _, _, _, Repeat, 2), ((Repeat == 1, !, fail) ; true)) ; true).

% Predicate that is called by the captureOponentPiece predicate, when the Mode is 2 (Player vs CPU).
% It checks if the current player is Human or CPU. If it is the Human, the AiLevel is checked.
% If the AiLevel is 1 or 2, a random Barragoon place and face is selected.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the opponent valid moves, to get a smart placement for the Barragoon.
% If it is the CPU, it asks the player for the coordinates and face of the Barragoon to place, validating the coordinates and that the selected place is empty.
% Then the board is updated, to place the Barragoon.
% After that, it checks if the current player is Human or CPU. If it is the CPU, the AiLevel is checked.
% If the AiLevel is 1 or 2, a random Barragoon place and face is selected.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the opponent valid moves, to get a smart placement for the Barragoon.
% If it is the Human, it asks the player for the coordinates and face of the Barragoon to place, validating the coordinates and that the selected place is empty.
% Then the board is updated, to place the Barragoon.
% It also displays the option of undoing the barragoon placement when the player is Human, as well as adding that to the list of made moves.

captureOponentPieceAux(P, Board, NewBoard, AiLevel, _, 2):-
  repeat,
    (
      (P == 1, nl, nl, write('Brown place your barragoon piece'), nl,
        (((AiLevel == 1 ; AiLevel == 2), getRandomBarragoonPiece(Board, Line, Column, BarragoonFace));
        (AiLevel == 3, getValuedValidMoves(Board, ValidMoves, 1), getBarragoonPieceSmartBot(Board, ValidMoves, Line, Column, BarragoonFace))),
        nl, write('Column of the place for the barragoon: '), write(Column), nl,
        write('Line of the place for the barragoon: '), write(Line), nl, nl,
        write('Press any key to continue: '), getChar(_), nl)
       ;

      (P == 2, nl, nl, write('White place your barragoon piece'), nl,
        getBarragoonCoords(Column, Line, BarragoonFace),
        getPiece(Board, Line, Column, Piece),
        ((Piece == 00) ; nl, nl, write('WARNING! Place chosen isn\'t empty!'), nl, nl, fail))
    ),
  !,
  addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
  printBoard(NewBoard), !,
  ((P == 2, getUndo(Board, _, _, _, Repeat, 2), ((Repeat == 1, !, fail) ; true)) ; (P == 1, true)).

% Predicate that is called by the captureOponentPiece predicate, when the Mode is 3 (CPU vs CPU).
% First it checks the AiLevel. If it is 1 or 2, a random Barragoon place and face is selected for the opponent player.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the current valid moves, to get a smart placement for the Barragoon.
% Then the board is updated, to place the Barragoon.
% After that, the AiLevel is checked. If it is 1 or 2, a random Barragoon place and face is selected for the current player.
% If the AiLevel is 3, the predicate getBarragoonPieceSmartBot is called, with the opponnent valid moves, to get a smart placement for the Barragoon.
% Then the board is updated, to place the Barragoon.
% It also adds the barragoon placement to the list of made moves.

captureOponentPieceAux(P, Board, NewBoard, AiLevel, AiSecondLevel, 3):-
  ((P == 1, nl, nl, write('Brown place your barragoon piece'), nl,
  (((AiSecondLevel == 1 ; AiSecondLevel == 2), getRandomBarragoonPiece(Board, Line, Column, BarragoonFace));
  (AiSecondLevel == 3, getValuedValidMoves(Board, ValidMoves, P), getBarragoonPieceSmartBot(Board, ValidMoves, Line, Column, BarragoonFace))))
  ;
  (P == 2, nl, nl, write('White place your barragoon piece'), nl,
  (((AiLevel == 1 ; AiLevel == 2), getRandomBarragoonPiece(Board, Line, Column, BarragoonFace));
  (AiLevel == 3, getValuedValidMoves(Board, ValidMoves, P), getBarragoonPieceSmartBot(Board, ValidMoves, Line, Column, BarragoonFace))))),

  nl, write('Column of the place for the barragoon: '), write(Column), nl,
  write('Line of the place for the barragoon: '), write(Line), nl, nl,
  write('Press any key to continue: '), getChar(_), nl,
  addMadeMove(3, _, _, _, Line, Column, BarragoonFace),
  updateBoard(Line, Column, BarragoonFace, Board, NewBoard),
  printBoard(NewBoard), !.

% Predicate that is called when the Mode is 1 (Player vs Player).
% It calls the predicate captureOponentPieceAux with Mode 1.

captureOponentPiece(Board, NewBoard2, 1, _, _):-
  player(P), ((P == 1, P1 is 2) ; (P == 2, P1 is 1)),
  repeat,
    captureOponentPieceAux(P, Board, NewBoard, _, _, 1),
  !, verifyEndGame(NewBoard),
  repeat,
    captureOponentPieceAux(P1, NewBoard, NewBoard2, _, _, 1),
  !.

% Predicate that is called when the Mode is 2 (Player vs CPU).
% It calls the predicate captureOponentPieceAux with Mode 2.

captureOponentPiece(Board, NewBoard2, 2, AiLevel, _):-
  player(P), ((P == 1, P1 is 2) ; (P == 2, P1 is 1)),
  repeat,
    captureOponentPieceAux(P, Board, NewBoard, AiLevel, _, 2),
  !, verifyEndGame(NewBoard),
  repeat,
    captureOponentPieceAux(P1, NewBoard, NewBoard2, AiLevel, _, 2),
  !.

% Predicate that is called when the Mode is 3 (CPU vs CPU).
% It calls the predicate captureOponentPieceAux with Mode 3.

captureOponentPiece(Board, NewBoard2, 3, AiLevel, AiSecondLevel):-
    player(P), ((P == 1, P1 is 2) ; (P == 2, P1 is 1)),
    captureOponentPieceAux(P, Board, NewBoard, AiLevel, AiSecondLevel, 3),
    !, verifyEndGame(NewBoard),
    captureOponentPieceAux(P1, NewBoard, NewBoard2, AiLevel, AiSecondLevel, 3).


% Predicate that gets a random place and face for the Barragoon.
% It first makes a list with all the free places in the board.
% Then it randomly chooses one of them.
% Finally it calls the predicate getRandomBarragoonFace to get a random Barragoon face.

getRandomBarragoonPiece(Board, Line, Column, BarragoonFace):-
    setof([L, C], freePiece(Board, L, C), BarragoonPieces),
    length(BarragoonPieces, NumBP),
    random(1, NumBP, ChosenPlaceNum),
    nth1(ChosenPlaceNum, BarragoonPieces, Place),
    nth1(1, Place, Line),
    nth1(2, Place, Column),
    getRandomBarragoonFace(BarragoonFace).

% Predicate that checks if a given piece is empty.

freePiece(Board, Line, Col):-
    getPiece(Board, Line, Col, Piece),
    Piece == 00.

% Predicate that generates a random Barragoon face.

getRandomBarragoonFace(Face):-
    random(1, 16, Num),
    ((Num == 1, Face is 30);
    (Num == 2, Face is 31);
    (Num == 3, Face is 32);
    (Num == 4, Face is 33);
    (Num == 5, Face is 34);
    (Num == 6, Face is 35);
    (Num == 7, Face is 36);
    (Num == 8, Face is 37);
    (Num == 9, Face is 40);
    (Num == 10, Face is 41);
    (Num == 11, Face is 42);
    (Num == 12, Face is 43);
    (Num == 13, Face is 44);
    (Num == 14, Face is 45);
    (Num == 15, Face is 46);
    (Num == 16, Face is 47)).

% Predicate that is used to get a Barragoon place and face, chosen in a smart way.
% First, it retrieves the opponnent moves size.
% Then, it gets the most valuable play of those.
% After that, it gets the coordinates of that and generates a random number between 1 and 4.
% It tries to place a barragoon in an adjacent position to the opponent piece that has the best play,
% in order to stop that move.
% The barragoon face is chosen accordingly
% If the new coordinates are not free, the predicate getRandomBarragoonPiece is called to generate
% a random place and face for the Barragoon.

getBarragoonPieceSmartBot(Board, OpponnentMoves, Line, Column, Piece):-
     (length(OpponnentMoves, SizeMoves),
     nth1(SizeMoves, OpponnentMoves, BestPlay),
     nth1(2, BestPlay, Pos),
     nth1(1, Pos, PieceLine),
     nth1(2, Pos, PieceCol),
     nth1(1, BestPlay, NewPos),
     nth1(2, NewPos, NewLine),
     nth1(3, NewPos, NewCol),
     random(1, 4, Num),

     ((PieceLine == NewLine, PieceCol > NewCol, Line is PieceLine, Column is PieceCol - 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 32);
     (Num == 3, Piece is 40);
     (Num == 4, Piece is 46)));

     (PieceLine == NewLine, PieceCol < NewCol, Line is PieceLine, Column is PieceCol + 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 33);
     (Num == 3, Piece is 42);
     (Num == 4, Piece is 44)));

     (PieceLine > NewLine, PieceCol == NewCol, Line is PieceLine - 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 34);
     (Num == 3, Piece is 41);
     (Num == 4, Piece is 45)));

     (PieceLine < NewLine, PieceCol == NewCol, Line is PieceLine + 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 31);
     (Num == 3, Piece is 43);
     (Num == 4, Piece is 47)));


     (PieceLine > NewLine, PieceCol > NewCol,
     ((Line is PieceLine - 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 34);
     (Num == 3, Piece is 41);
     (Num == 4, Piece is 45)));
     (Line is PieceLine, Column is PieceCol - 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 32);
     (Num == 3, Piece is 40);
     (Num == 4, Piece is 46)))));

     (PieceLine > NewLine, PieceCol < NewCol,
     ((Line is PieceLine - 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 34);
     (Num == 3, Piece is 41);
     (Num == 4, Piece is 45)));
     (Line is PieceLine, Column is PieceCol + 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 33);
     (Num == 3, Piece is 42);
     (Num == 4, Piece is 44)))));

     (PieceLine < NewLine, PieceCol > NewCol,
     ((Line is PieceLine + 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 31);
     (Num == 3, Piece is 43);
     (Num == 4, Piece is 47)));
     (Line is PieceLine, Column is PieceCol - 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 32);
     (Num == 3, Piece is 40);
     (Num == 4, Piece is 46)))));

     (PieceLine < NewLine, PieceCol < NewCol,
     ((Line is PieceLine + 1, Column is PieceCol, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 31);
     (Num == 3, Piece is 43);
     (Num == 4, Piece is 47)));
     (Line is PieceLine, Column is PieceCol + 1, getPiece(Board, Line, Column, Piece1), Piece1 == 0,
     ((Num == 1, Piece is 30);
     (Num == 2, Piece is 33);
     (Num == 3, Piece is 42);
     (Num == 4, Piece is 44)))))));


     getRandomBarragoonPiece(Board, Line, Column, Piece).

% Predicate that shows in the screen whose turn is it.

tellPlayerToPlay(_):-
  ((player(P), P == 1, nl, write('White turn!')) ;
   (player(P), P == 2, nl, write('Brown turn!'))), nl, nl.

% Predicate that asks the player for the coordinates of the piece to move.

getPieceCurCoords(X, Y):-
  repeat,
    write('Give the column of the piece to move (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the piece to move (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !.

% Predicate that asks the player for the new coordinates to place the piece.

getPieceNewCoords(X, Y):-
  repeat,
    write('Give the column of the new position for the piece (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the new position for the piece (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !.

% Predicate that asks the player for the coordinates of the Barragoon to place, as well as its face.

getBarragoonCoords(X, Y, Z):-
  repeat,
    nl,write('Give the column of the new position for the barragoon piece (between 1 and 7):'),
    getDigit(X),
    checkColumn(X),
  !,
  repeat,
    write('Give the line of the new position for the barragoon piece (between 1 and 9):'),
    getDigit(Y),
    checkLine(Y),
  !,
  repeat,
    nl,
    write('Choose the face of the barragoon piece to place:'),
    nl,
    nl,
    write('    x x x      ^ ^ ^      ---->      <----      | | |      ^ ^ ^      <--->        ^  '),
    nl,
    write('30- x x x  31- | | |  32- ---->  33- <----  34- | | |  35- | | |  36- <--->  37- < + >'),
    nl,
    write('    x x x      | | |      ---->      <----      v v v      v v v      <--->        v  '),
    nl,
    nl,
    write('    +--->      ----+        | |      ^ ^        <---+      +----      | |          ^ ^'),
    nl,
    write('40- | +->  41- --+ |  42- <-+ |  43- | +--  44- <-+ |  45- | +--  46- | +->  47- --+ |'),
    nl,
    write('    | |          v v      <---+      +----        | |      v v        +--->      ----+'),
    nl, nl,
    getDoubleDigit(Z),
    checkBarragoonFace(Z),
  !.

% Predicate that checks if the Piece selected is empty, and if it belongs to the current player or not.

checkPieceFromCurrentPlayer(Board, Line, Column):-
  getPiece(Board, Line, Column, Piece),
  % Checks if the selected position contains a piece
  ((Piece == 00, nl, write('WARNING! Cannot choose empty position!'), nl, nl, !, fail);
  % Checks if the piece selected corresponds to the player currently playing
  (((player(P), P == 1, (Piece == 12 ; Piece == 13 ; Piece == 14)) ;
   (player(P), P == 2, (Piece == 22 ; Piece == 23 ; Piece == 24))) ;
   nl, write('WARNING! Cannot choose opponent/barragoon piece!'), nl, nl, !, fail)).

% Predicate that is used to validate a move.
% First it retrieves the piece from the given coordinates for it.
% Then it verifies if the new coordinates contain a piece that belongs to the current player.
% After that, it retrieves the whatever the new coordinates contain and calls the predicate
% verifyNewPosInRange and the predicate verifyPieceInTheWay.

validateMove(Board, Line, Column, NewLine, NewColumn, Player):-
  getPiece(Board, Line, Column, Piece),
  checkNewPosPiece(Board, NewLine, NewColumn, Player),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  !,
  verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn),
  !,
  verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board).

% Predicate that is used to validate a move for the bots (without showing messages).
% First it retrieves the piece from the given coordinates for it.
% Then it verifies if the new coordinates contain a piece that belongs to the current player.
% After that, it retrieves the whatever the new coordinates contain and calls the predicate
% verifyNewPosInRange and the predicate verifyPieceInTheWay.

validateMoveNoMessages(Board, Line, Column, NewLine, NewColumn, Player):-
  getPiece(Board, Line, Column, Piece),
  checkNewPosPieceNoMessages(Board, NewLine, NewColumn, Player),
  getPiece(Board, NewLine, NewColumn, NewPiece),
  verifyNewPosInRangeNoMessages(NewPiece, Piece, Line, Column, NewLine, NewColumn),
  verifyPieceInTheWayNoMessages(Line, Column, NewLine, NewColumn, Board).

% Predicate that checks if the new coordinates contain a piece that belongs to the current player.
% If it does, a warning message is displayed.

checkNewPosPiece(Board, NewLine, NewColumn, Player):-
  getPiece(Board, NewLine, NewColumn, NewPiece),
  (((Player == 1, (NewPiece =\= 12 , NewPiece =\= 13 , NewPiece =\= 14)) ;
   (Player == 2, (NewPiece =\= 22 , NewPiece =\= 23 , NewPiece =\= 24))) ;
   nl, write('WARNING! Cannot capture your own pieces!'), nl, nl, !, fail).

% Predicate that checks if the new coordinates contain a piece that belongs to the current player.
% If it does, the predicate fails. This is called in the bots moves validation, therefore no messages are shown.

checkNewPosPieceNoMessages(Board, NewLine, NewColumn, Player):-
  getPiece(Board, NewLine, NewColumn, NewPiece),
  (((Player == 1, (NewPiece =\= 12 , NewPiece =\= 13 , NewPiece =\= 14)) ;
   (Player == 2, (NewPiece =\= 22 , NewPiece =\= 23 , NewPiece =\= 24))) ;
   fail).

% Predicate that is called when the new coordinates are empty.
% Checks if the new coordinates are inside the range of the selected piece to move.

verifyNewPosInRange(00, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      ((((NewLine =:= Line); (NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column); (NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      (nl, write('WARNING! Invalid move!'), nl, nl, !, fail))) ;

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1); (NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (nl, write('WARNING! Invalid move!'), nl, nl, !, fail))) ;

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3); (NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3); (NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      (nl, write('WARNING! Invalid move!'), nl, nl, !, fail))).

% Predicate that is called when the new coordinates contain a piece.
% Checks if the new coordinates are inside the range of the selected piece to move,
% and if there isnt an attempt to capture with short moves.

verifyNewPosInRange(NewPiece, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      (((NewPiece == 37), nl, write('WARNING! Cannot capture all turns with 2-space!'), nl, nl, !, fail);
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      (nl, write('WARNING! New position is out of range or cannot capture with short move!'), nl, nl, !, fail))));

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (nl, write('WARNING! New position is out of range or cannot capture with short move!'), nl, nl, !, fail))) ;

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      (nl, write('WARNING! New position is out of range or cannot capture with short move!'), nl, nl, !, fail))).

% Predicate that is called when the new coordinates are empty.
% Checks if the new coordinates are inside the range of the selected piece to move.
% This is called in the bots moves validation, therefore no messages are shown.

verifyNewPosInRangeNoMessages(00, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      ((((NewLine =:= Line); (NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column); (NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      !, fail)) ;

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1); (NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      !, fail)) ;

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2); (NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2); (NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3); (NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3); (NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      !, fail)).

% Predicate that is called when the new coordinates contain a piece.
% Checks if the new coordinates are inside the range of the selected piece to move,
% and if there isnt an attempt to capture with short moves.
% This is called in the bots moves validation, therefore no messages are shown.

verifyNewPosInRangeNoMessages(NewPiece, Piece, Line, Column, NewLine, NewColumn):-

  ((Piece == 12 ; Piece == 22),
      (((NewPiece == 37), !, fail);
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      !, fail)));

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      !, fail));

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      !, fail)).

% Predicate that is used to check if a given play is long move.
% This is called in the bots moves validation, therefore no messages are shown.

verifyLongMoveNoMessages(Board, Line, Column, NewLine, NewColumn):-
  getPiece(Board, Line, Column, Piece),
  getPiece(Board, NewLine, NewColumn, NewPiece),

  (((Piece == 12 ; Piece == 22),
      (((NewPiece == 37), !, fail);
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)),
      ((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      !, fail)));

  ((Piece == 13 ; Piece == 23),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 2); (NewLine =:= Line - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      !, fail));

  ((Piece == 14 ; Piece == 24),
      ((((NewLine =:= Line + 1); (NewLine =:= Line - 1)), ((NewColumn =:= Column + 3); (NewColumn =:= Column - 3)));
      (((NewColumn =:= Column + 1); (NewColumn =:= Column - 1)), ((NewLine =:= Line + 3); (NewLine =:= Line - 3)));
      (((NewLine =:= Line + 2); (NewLine =:= Line - 2)), ((NewColumn =:= Column + 2); (NewColumn =:= Column - 2)));
      ((NewLine =:= Line), ((NewColumn =:= Column + 4); (NewColumn =:= Column - 4)));
      ((NewColumn =:= Column), ((NewLine =:= Line + 4); (NewLine =:= Line - 4)));
      !, fail))).

auxLine(_Line, _Column, _Board, 1).
auxLine(_Line, _Column, _Board, -1).

% Predicate that goes to every line and checks if every position in that line allows passage.

auxLine(Line, Column, Board, C):-
  (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
  NewColumn is Column + C1,
  getPiece(Board, Line, NewColumn, Piece),
  ((((Piece == 00) ; (Piece == 36) ; (((C > 0), (Piece == 32)) ; ((C < 0), (Piece == 33)))), auxLine(Line, Column, Board, C1)) ;
  !, fail).

auxColumn(_Line, _Column, _Board, 1).
auxColumn(_Line, _Column, _Board, -1).

% Predicate that goes to every column and checks if every position in that column allows passage.

auxColumn(Line, Column, Board, C):-
    (((C > 0), C1 is C - 1) ; ((C < 0), C1 is C + 1)) ,
    NewLine is Line + C1,
    getPiece(Board, NewLine, Column, Piece),
    ((((Piece == 00) ; (Piece == 35) ; (((C > 0), (Piece == 34)) ; ((C < 0), (Piece == 31)))), auxColumn(Line, Column, Board, C1)) ;
    !, fail).

% Predicate that checks if the given coordinates contain a curve (or empty position) that would allow passage in the desired way.

verifyCurve(Line, Column, Board, LineC, ColC):-
    getPiece(Board, Line, Column, Piece),
    ((Piece == 37);
    (Piece == 00);
    ((LineC == 1), (ColC > 0), (Piece == 46));
    ((LineC == 1), (ColC < 0), (Piece == 42));
    ((LineC == -1), (ColC > 0), (Piece == 40));
    ((LineC == -1), (ColC < 0), (Piece == 44));
    ((LineC > 0), (ColC == 1), (Piece == 41));
    ((LineC < 0), (ColC == 1), (Piece == 47));
    ((LineC > 0), (ColC == -1), (Piece == 45));
    ((LineC < 0), (ColC == -1), (Piece == 43))).

% Predicate that checks if the path for the given move (which contains a curve) is free, or has something in the way.

verifyDiagonalWay(Line, Column, Board, LineC, ColC):-
    ((ColC > 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, 1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC > 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, 1, ColC), auxLine(NewLine, Column, Board, ColC));
    ((ColC < 0),auxLine(Line, Column, Board, ColC), NewColumn is Column + ColC, verifyCurve(Line, NewColumn, Board, LineC, -1), auxColumn(Line, NewColumn, Board, LineC));
    ((LineC < 0),auxColumn(Line, Column, Board, LineC), NewLine is Line + LineC, verifyCurve(NewLine, Column, Board, -1, ColC), auxLine(NewLine, Column, Board, ColC)).

% Predicate that checks if the path for the given move is free.
% First it will check if the line of the piece is the same as the line of the destination and if it is, it will call the predicate auxLine.
% If the Line is not the same, it will check if the column of the piece is the same as the column of the destination and if it is,
% it will call the predicate auxColumn.
% If the Column is not the same, it will calculate the difference between the Lines, calculate the difference between the Columns and then
% call the predicate verifyDiagonalWay.
% If none of the conditions above return true, a message is shown in the screen warning that something
% is in the way of the desired move and fail.

verifyPieceInTheWay(Line, Column, NewLine, NewColumn, Board):-
    (((Line == NewLine), ColC is (NewColumn - Column), auxLine(Line, Column, Board, ColC)) ;
     ((Column == NewColumn), LineC is (NewLine - Line), auxColumn(Line, Column, Board, LineC)) ;
     (ColC is (NewColumn - Column), LineC is (NewLine - Line), verifyDiagonalWay(Line, Column, Board, LineC, ColC)) ;
     (nl, write('WARNING! Something is in the way!'), nl, nl, !, fail)).

% Predicate that checks if the path for the given move is free.
% First it will check if the line of the piece is the same as the line of the destination and if it is, it will call the predicate auxLine.
% If the Line is not the same, it will check if the column of the piece is the same as the column of the destination and if it is,
% it will call the predicate auxColumn.
% If the Column is not the same, it will calculate the difference between the Lines, calculate the difference between the Columns and then
% call the predicate verifyDiagonalWay.
% If none of the conditions above return true, a message is shown in the screen warning that something
% is in the way of the desired move and fail.
% This is called in the bots moves validation, therefore no messages are shown.

verifyPieceInTheWayNoMessages(Line, Column, NewLine, NewColumn, Board):-
     (((Line == NewLine), ColC is (NewColumn - Column), auxLine(Line, Column, Board, ColC)) ;
     ((Column == NewColumn), LineC is (NewLine - Line), auxColumn(Line, Column, Board, LineC)) ;
     (ColC is (NewColumn - Column), LineC is (NewLine - Line), verifyDiagonalWay(Line, Column, Board, LineC, ColC)) ;
     fail).

% Bots move predicates

% Predicate that uses the setof predicate to get a list of the valid moves for the given player.

getValidMoves(Board, ValidMoves, Player) :-
    setof([[NewLine, NewCol], [PieceLine, PieceCol]],(getPlayerPieces(Board, Player, PieceCol, PieceLine),
    validateMoveNoMessages(Board, PieceLine, PieceCol, NewLine, NewCol, Player)), ValidMoves).

% Predicate that uses the setof predicate to get the valid moves for the given player.
% It also sets a value to each valid move accordingly.
% But in this case it is checked if the place of destination is one of the oponnents
% destination as well. If it is, this destination is descarted.

getValuedValidMovesAvoidCapture(Board, ValidMoves, Player):-
    ((Player == 1, P1 is 2) ; (Player == 2, P1 is 1)),
    (setof([[Value, NewLine, NewCol], [PieceLine, PieceCol]],(getPlayerPieces(Board, Player, PieceCol, PieceLine),
    validateMoveNoMessages(Board, PieceLine, PieceCol, NewLine, NewCol, Player),
    checkMoveForInCheckPlace(Board, P1, NewLine, NewCol),
    setMoveValue(Board, NewLine, NewCol, Value)),
    ValidMoves) ; true).

% Predicate that uses the setof predicate to get the valid moves for the given player.
% It also sets a value to each valid move accordingly.

getValuedValidMovesNormal(Board, ValidMoves, Player):-
    (setof([[Value, NewLine, NewCol], [PieceLine, PieceCol]],(getPlayerPieces(Board, Player, PieceCol, PieceLine),
    validateMoveNoMessages(Board, PieceLine, PieceCol, NewLine, NewCol, Player),
    setMoveValue(Board, NewLine, NewCol, Value)),
    ValidMoves) ; true).

% Predicate that gives the valid moves for the current player.
% It first gets the valued valid moves wich do not contain in danger destinations.
% In case this has length = 0, the predicate getValuedValidMovesNormal is called to give the valued valid moves, not avoiding capture.
% In case this has length > 0, the oponnent valued moves are retrieved and the best oponnent move is analised.
% If the value of the oponnent best move  is greater than 1 and greater than the value of the current player best move,
% the returned valid moves will be the ones that allow the piece, in danger of capture by the oponnent, to move to a not in danger destination.
% If there is none destination that allows that, the returned valid moves will be the ones wich do not contain in danger destinations.

getValuedValidMoves(Board, ValidMoves, Player):-
    getValuedValidMovesAvoidCapture(Board, PlayerMoves, Player),
    length(PlayerMoves, NumPM),
    ((NumPM == 0, getValuedValidMovesNormal(Board, ValidMoves, Player)) ;
    (((Player == 1, P1 is 2, getValuedValidMovesNormal(Board, OpponnentMoves, P1)) ; (Player == 2, P1 is 1, getValuedValidMovesNormal(Board, OpponnentMoves, P1))),
    length(OpponnentMoves, NumOM),
    nth1(NumOM, OpponnentMoves, BestOpMove),
    nth1(1, BestOpMove, BestOpMoveCoords),
    nth1(1, BestOpMoveCoords, ValueOpMove),

    nth1(NumPM, PlayerMoves, BestPlMove),
    nth1(1, BestPlMove, BestPlMoveCoords),
    nth1(1, BestPlMoveCoords, ValuePlMove),

     ((ValueOpMove > 1,
     ValueOpMove > ValuePlMove,
     nth1(2, BestOpMoveCoords, PieceLine),
     nth1(3, BestOpMoveCoords, PieceCol),

     getValidMoves(Board, OpBestPieceMoves, P1),
     length(OpBestPieceMoves, NumOpBestPieceMoves),

     setof([[Value, NewLine, NewCol], [PieceLine, PieceCol]],
     (validateMoveNoMessages(Board, PieceLine, PieceCol, NewLine, NewCol, Player),
     checkElemNotInList(Board, NewLine, NewCol, OpBestPieceMoves, NumOpBestPieceMoves),
     setMoveValue(Board, NewLine, NewCol, Value)),
     ValidMoves),

     length(ValidMoves, NumValidMoves),
     (NumValidMoves > 0)) ;
     (ValidMoves = PlayerMoves)))).

checkElemNotInList(_Board, _NewLine, _NewCol, _List, 0).

% Predicate that checks if a given element belongs to a list.

checkElemNotInList(Board, NewLine, NewCol, List, N):-
    nth1(N, List, E1),
    nth1(1, E1, Coords),
    nth1(1, Coords, OpLine),
    nth1(2, Coords, OpCol),
    nth1(2, E1, PieceCoords),
    nth1(1, PieceCoords, PieceLine),
    nth1(2, PieceCoords, PieceCol),
    ((NewLine == OpLine , NewCol == OpCol, verifyLongMoveNoMessages(Board, PieceLine, PieceCol, OpLine, OpCol), !, fail) ;
    (N1 is N - 1, checkElemNotInList(Board, NewLine, NewCol, List, N1))) .

% Predicate that checks if a given destination is present in the oponnent valid moves list.

checkMoveForInCheckPlace(Board, Player2, NewLine, NewCol):-
    (getValidMoves(Board, OpponentMoves, Player2) ; true),
    length(OpponentMoves, NumOpMoves),
    !,
    checkElemNotInList(Board, NewLine, NewCol, OpponentMoves, NumOpMoves).

% Predicate that gives the given player pieces.

getPlayerPieces(Board, Player, Col, Line):-
    getPiece(Board, Line, Col, Piece),
    ((Player == 1, (Piece == 12; Piece == 13; Piece == 14));
    (Player == 2, (Piece == 22; Piece == 23; Piece == 24))).

% Predicate that gives a certain move a value, according to the piece present in the destination.

setMoveValue(Board, NewLine, NewCol, Value):-
    getPiece(Board, NewLine, NewCol, Piece),
    (((Piece == 00), Value is 0);
     ((((Piece >= 30) , (Piece =< 37)) ; ((Piece >= 40) , (Piece =< 47))), Value is 1);
     ((Piece == 12 ; Piece == 22), Value is 2);
     ((Piece == 13 ; Piece == 23), Value is 3);
     ((Piece == 14 ; Piece == 24), Value is 4)).
