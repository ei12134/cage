% human vs human mode
human_vs_human(Game):-
        %                initial_board(Board),
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, hvh, noForceJump, 0, 0], !.

% human vs computer mode
human_vs_computer(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, hvc, noForceJump, 0, 0], !.

% human vs computer mode
computer_vs_computer(Game):-
        %        bot_test_board(Board),
        %        bot_win_test_board(Board),
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, cvc, noForceJump, 0, 0], !.

% board procedures
get_board([Board|_], Board).

set_board(Board, Game, ModifiedGame):-
        set_list_element(0, Board, Game, ModifiedGame).

% board evaluation
get_evaluation(Game,Player,Evaluation):-
        get_num_red_pieces(Game, NumRedPieces),
        get_num_blue_pieces(Game, NumBluePieces),
        (
           Player == redPlayer -> Evaluation is NumRedPieces - NumBluePieces;
           Player == bluePlayer -> Evaluation is NumBluePieces - NumRedPieces
        ),!.

% pieces procedures
get_num_board_pieces(Game,ListOfPieces):-
        get_list_element(1,Game,ListOfPieces).

set_num_board_pieces(NumPiecesList, Game, ModifiedGame):-
        set_list_element(1, NumPiecesList, Game, ModifiedGame).

get_num_red_pieces(Game,NumRedPieces):-
        get_num_board_pieces(Game,ListOfPieces),
        get_list_element(0,ListOfPieces,NumRedPieces).

set_num_red_pieces(NumRedPieces, Game, ModifiedGame):-
        get_num_board_pieces(Game, NumPiecesList),
        set_list_element(0, NumRedPieces, NumPiecesList, ResNumPiecesList),
        set_num_board_pieces(ResNumPiecesList, Game, ModifiedGame).

get_num_blue_pieces(Game,NumBluePieces):-
        get_num_board_pieces(Game,ListOfPieces),
        get_list_element(1,ListOfPieces,NumBluePieces).

set_num_blue_pieces(NumBluePieces, Game, ModifiedGame):-
        get_num_board_pieces(Game, NumPiecesList),
        set_list_element(1, NumBluePieces, NumPiecesList, ResNumPiecesList),
        set_num_board_pieces(ResNumPiecesList, Game, ModifiedGame).

dec_piece(Piece,Game,ModifiedGame):-
        (
           Piece == red -> dec_num_red_pieces(Game, ModifiedGame);
           Piece == blue -> dec_num_blue_pieces(Game, ModifiedGame)
        ),!.

dec_num_red_pieces(Game, ModifiedGame):-
        get_num_red_pieces(Game, NumRedPieces),
        NumRedPieces1 is NumRedPieces - 1,
        set_num_red_pieces(NumRedPieces1, Game, ModifiedGame).

dec_num_blue_pieces(Game, ModifiedGame):-
        get_num_blue_pieces(Game, NumBluePieces),
        NumBluePieces1 is NumBluePieces - 1,
        set_num_blue_pieces(NumBluePieces1, Game, ModifiedGame).

% player
get_player_turn(Game,Player):-
        get_list_element(2,Game,Player).

get_previous_turn(Game,PreviousPlayer):-
        get_list_element(2,Game,Player),
        Player == redPlayer, PreviousPlayer = bluePlayer;
        PreviousPlayer = redPlayer.


set_player_turn(Player, Game, ModifiedGame):-
        set_list_element(2, Player, Game, ModifiedGame).

change_player_turn(TemporaryGame,ModifiedGame):-
        get_player_turn(TemporaryGame,OldTurn),
        (
           OldTurn == redPlayer -> NewTurn = bluePlayer;
           OldTurn == bluePlayer -> NewTurn = redPlayer
        ), set_player_turn(NewTurn,TemporaryGame,ModifiedGame),!.

get_enemy_piece(Player, EnemyPiece):-
        piece_owned_by(PlayerPiece,Player),
        (
           PlayerPiece == red -> EnemyPiece = blue;
           PlayerPiece == blue -> EnemyPiece = red
        ).

% game mode
get_mode(Game,Mode):-
        get_list_element(3,Game,Mode).

% jump forcing variable
get_force_jump(Game,ForceMode):-
        get_list_element(4,Game,ForceMode).

get_force_starting_row(Game,Row):-
        get_list_element(5,Game,Row).

get_force_starting_col(Game,Col):-
        get_list_element(6,Game,Col).

set_force_jump(ForceMode, ForceStartingRow, ForceStartingCol, Game, ModifiedGame):-
        set_list_element(4, ForceMode, Game, TemporaryGame),
        set_force_jump_starting_row(ForceStartingRow, TemporaryGame, TemporaryGame2),
        set_force_jump_starting_col(ForceStartingCol, TemporaryGame2, ModifiedGame).

set_force_jump_starting_row(Row, Game, ModifiedGame):-
        set_list_element(5, Row, Game, ModifiedGame).

set_force_jump_starting_col(Col, Game, ModifiedGame):-
        set_list_element(6, Col, Game, ModifiedGame).

