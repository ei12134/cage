% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('logic.pl').
:- include('board.pl').

% program starting point
%cage :- main_menu.
cage :- board(B), display_board(B,8).