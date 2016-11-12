% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('utils.pl').
:- include('cli.pl').
:- include('game.pl').
:- include('board.pl').
:- include('logic.pl').

% program starting point
cage:- main_menu.

% players and pieces
player(redPlayer).
player(bluePlayer).

get_player_name(redPlayer, 'Red').
get_player_name(bluePlayer, 'Blue').

player_ownes_cell(Row,Col,Game):-
        get_board(Game,Board),
        get_player_turn(Game,Player),
        get_board_cell(Row,Col,Board,Cell),
        piece_owned_by(Cell,Player).

game_loop(Game):- 
        validate_board_pieces(Game),
        get_board(Game, Board),
        display_board(Board,8),
        human_play(Game, ModifiedGame),
        game_loop(ModifiedGame).

game_loop(Game):-
        get_enemy_turn(Game, PreviousPlayer),
        write('Game has ended - '), write(PreviousPlayer), write(' wins.'), nl.

human_play(Game, ModifiedGame):-
        get_player_turn(Game, Player),
        get_board(Game, Board),

        repeat,
        display_turn_info(Player), nl,
        get_moving_piece_source_coordinates(SrcRow, SrcCol), 
        validate_piece_owner(SrcRow, SrcCol, Board, Player),

        get_force_jump(Game,ForceMode),
        get_force_starting_row(Game,ForceJumRow),
        get_force_starting_col(Game,ForceJumCol),

        (
           ForceMode == forceJump -> write('A jumping move from the same spot is mandatory'), nl,
                                     SrcRow == ForceJumRow, SrcCol == ForceJumCol;
           true
        ),

        get_piece_destiny_coordinates(DestRow, DestCol), 
        validate_source_to_destiny_delta(SrcRow, SrcCol, DestRow, DestCol),

        (
           ForceMode == forceJump -> write('A jumping move is mandatory'), nl,
                                     get_enemy_piece(Player, EnemyPiece),
                                     validate_cell_contents(DestRow, DestCol, Board, EnemyPiece);
           validate_destiny_cell_type(DestRow, DestCol, Board, Player)
        ),

        make_move(SrcRow, SrcCol, DestRow, DestCol, Game, ModifiedGame), !.
