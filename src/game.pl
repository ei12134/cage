% human vs human mode
hvh(Game):-
        %        initial_board(Board),
        test_board(Board),
        Game = [Board, [32, 32], redPlayer, hvh, noForceJump, 0, 0], !.

% board procedures
get_board([Board|_], Board).

set_board(Board, Game, ModifiedGame):-
        set_list_element(0, Board, Game, ModifiedGame).

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
        get_list_element(0,ListOfPieces,NumBluePieces).

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

