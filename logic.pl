startGame :-
initialBoard(Board),
Play is 1,
play_cicle(Board, Play).

play_cicle(Board, Play):-
  printBoard(Board),
  play(Board, NewBoard, Play),
  NewPlay is Play + 1,
  play_cicle(NewBoard, NewPlay).

play(Board, NewBoard, Play):-
  repeat,
    get_play(),
  !,
  move().

get_play(Board, NewBoard, Play, Line, Column, NewLine, NewColumn):-
  determinePlayer(Play),




determinePlayer(Play):-
  
