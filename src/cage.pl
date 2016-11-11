% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('utils.pl').
:- include('cli.pl').
:- include('board.pl').
%:- include('logic.pl').

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

game_loop(Game) :- 
        validate_board_pieces(Game),
        human_play(Game).

game_loop(_) :-
        %        get_board(Game, Board),
        %        display_board(Board),
        write('Game has ended - Player X wins'), nl.

human_play(Game):-
        get_board(Game, Board),
        display_board(Board,8),
        get_player_turn(Game, Player),

        repeat,

        display_turn_info(Player), nl,
        get_moving_piece_source_coordinates(SrcRow, SrcCol),
        validate_piece_owner(SrcRow, SrcCol, Board, Player),
        get_piece_destiny_coordinates(DestRow, DestCol),
        validate_destiny_cell_type(SrcRow, SrcCol, Board, Player).
%        validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
%        change_player(TempGame, ResultantGame), !.

validate_destiny_cell_type(SrcRow, SrcCol, Board, Player):-
        get_matrix_element(SrcRow, SrcCol, Board, Piece),
        \+piece_owned_by(Piece, Player), !.
validate_destiny_cell_type(_, _, _, _):-
        write('Invalid destiny cell!'), nl,
        fail.

validate_piece_owner(SrcRow, SrcCol, Board, Player):-
        get_matrix_element(SrcRow, SrcCol, Board, Piece),
        piece_owned_by(Piece, Player), !.
validate_piece_owner(_, _, _, _):-
        write('Invalid piece!'), nl,
        fail.
