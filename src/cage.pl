% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('cli.pl').
:- include('logic.pl').
:- include('board.pl').
:- include('utils.pl').

% program starting point
cage :- main_menu.

%players and pieces
player(redPlayer).
player(bluePlayer).

get_player_name(redPlayer, 'Red').
get_player_name(bluePlayer, 'Blue').

get_player_turn(Game,Player):-
        get_list_element(2,Game,Player).

player_ownes_cell(Row,Col,Game):-
        get_board(Game,Board),
        get_player_turn(Game,Player),
        get_board_cell(Row,Col,Board,Cell),
        piece_owned_by(Cell,Player).

% Human vs Human game mode
hvh(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, hvh], !.

start(Game) :- get_board(Game, Board), display_board(Board,8), get_piece_src_coord(SrcRow, SrcCol), print(SrcRow, SrcCol), nl.
