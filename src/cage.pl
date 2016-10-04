% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('board.pl').
:- include('logic.pl').

% program starting point
%cage :- main_menu.
cage :- board(B), display_board(B).