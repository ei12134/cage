% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('utils.pl').
:- include('cli.pl').
:- include('game.pl').
:- include('computer.pl').
:- include('board.pl').
:- include('logic.pl').

% program starting pointc
cage:- 
        initialize_random_seed,
        main_menu.

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
        get_mode(Game, GameMode),
        (
           GameMode == cvc -> (computer_play(0,Game,ModifiedGame));
           GameMode == hvc -> (
                                 (get_player_turn(Game, Player), Player \== redPlayer) -> computer_play(0, Game, ModifiedGame);
                                 human_play(Game, ModifiedGame)
                              );
           human_play(Game, ModifiedGame)
        ),!,
          game_loop(ModifiedGame).

game_loop(Game):-
        get_board(Game, Board),
        display_board(Board,8),
        determine_winner(Game, Winner),
        nl, write('Game has ended - '), write(Winner), write(' wins.'), nl.

determine_winner(Game, Winner):-
        get_previous_turn(Game, PreviousPlayer),
        get_num_red_pieces(Game,NumRedPieces),
        get_num_blue_pieces(Game,NumBluePieces),

        (
           NumRedPieces > 0 -> Winner = redPlayer;
           NumBluePieces > 0 -> Winner = bluePlayer;
           Winner = PreviousPlayer
        ).


human_play(Game, ModifiedGame):-
        get_player_turn(Game, Player),
        get_board(Game, Board),

        repeat,
        display_turn_info(Game), nl,
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
