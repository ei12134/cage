% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('cli.pl').
:- include('logic.pl').
:- include('board.pl').

% program starting point
cage :- main_menu.

% Human vs Human game mode
hvh(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], red, hvh], !.

start(Game) :- get_board(Game, Board), display_board(Board,8).

get_board([Board|_], Board).

