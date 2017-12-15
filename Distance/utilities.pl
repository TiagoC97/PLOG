:- use_module(library(lists)).
:- use_module(library(random)).

% Function used to clear screen
cls :- write('\e[2J').

% Functions to get the user input

% if after the digit/char, the user inputs other characters,
% these are ignored until the user inputs a new line (which is also ignored)

waitNewLine:- get_code(L), ite(L == 10, !, waitNewLine).

getDigit(D):- get_code(D1), D is D1 - 48, ite(D1 == 10, !, waitNewLine), !.

getDoubleDigit(D):- get_code(D1), D2 is D1 - 48, get_code(D3), D4 is D3 - 48, D is (D2*10) + D4, ite(D1 == 10, !, waitNewLine), !.

getChar(C):- get_char(C), char_code(C, C1), ite(C1 == 10, !, waitNewLine).

% Implementation of an if statement

ite(If, Then, _Else):- If, !, Then.
ite(_, _, Else):- Else.
