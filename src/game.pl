% human vs human mode
hvh(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], redPlayer, hvh], !.

% board procedures
get_board([Board|_], Board).

% pieces procedures
get_num_board_pieces(Game,ListOfPieces):-
        get_list_element(1,Game,ListOfPieces).

get_num_red_pieces(Game,NumRedPieces):-
        get_num_board_pieces(Game,ListOfPieces),
        get_list_element(0,ListOfPieces,NumRedPieces).

get_num_blue_pieces(Game,NumBluePieces):-
        get_num_board_pieces(Game,ListOfPieces),
        get_list_element(0,ListOfPieces,NumBluePieces).