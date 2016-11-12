% human vs human mode
hvh(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, hvh], !.

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


