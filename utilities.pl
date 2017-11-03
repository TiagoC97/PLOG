:- use_module(library(lists)).

% Function used to clear screen
cls :- write('\e[2J').

% Functions to get the user input

% if after the digit/char, the user inputs other characters,
% these are ignored until the user inputs a new line (which is also ignored)

waitNewLine:- get_code(L), ite(L == 10, !, waitNewLine).

getDigit(D):- get_code(D1), D is D1 - 48, ite(D1 == 10, !, waitNewLine).
getChar(C):- get_char(C), char_code(C, C1), ite(C1 == 10, !, waitNewLine).

% Implementation of an if statement

ite(If, Then, Else):- If, !, Then.
ite(_, _, Else):- Else.

% Determine if a given Play is even or odd
even(Playe):- Play mod 2 =:= 0.

odd(Play):- Play mod 2 =:= 1.
