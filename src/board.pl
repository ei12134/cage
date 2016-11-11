:- include('utils.pl').

get_board([Board|_], Board).

get_board_cell(0,Col,[HeadList|_],Symbol):-
        get_list_elem(Col,HeadList,Symbol).

get_board_cell(Row,Col,[_|TailList], Symbol):-
        Row >0,
        Row1 is Row-1,
        get_board_cell(Row1,Col,TailList,Symbol).

get_cell_symbol(emptyCell,' ').
get_cell_symbol(redCell,'x').
get_cell_symbol(blueCell,'o').

piece_owned_by(redCell,redPlayer).
piece_owned_by(blueCell,bluePlayer).

piece(redPiece).
piece(bluePiece).

% piece input functions 
get_piece_src_coord(SrcRow, SrcCol):-
        write("Enter the row and column (ex. a1) of the piece you want to move and press <Enter>"), nl,
        input_coords(SrcRow,SrcCol), nl.

get_piece_dest_coord(DstRow, DstCol):-
        write("Enter the row and column (ex. b1) of the piece you want to move and press <Enter>"), nl,
        input_coords(DstRow,DstCol), nl.

% pieces functions
get_num_pieces_in_board(Game,ListOfPieces):-
        get_list_elem(1,Game,ListOfPieces).

get_num_red_pieces(Game,NumRedPieces):-
        get_num_pieces_in_board(Game,ListOfPieces),
        get_list_elem(0,ListOfPieces,NumRedPieces).

get_num_blue_pieces(Game,NumBluePieces):-
        get_num_pieces_in_board(Game,ListOfPieces),
        get_list_elem(0,ListOfPieces,NumBluePieces).

% board functions
check_players_board_pieces(Game):-
        get_num_red_pieces(Game,NumRedPieces),
        get_num_blue_pieces(Game,NumBluePieces),
        NumRedPieces > 0,
        NumBluePieces > 0,!.

% container
initial_board([[blue,red,blue,red,blue,red,blue,red],
               [red,blue,red,blue,red,blue,red,blue],
               [blue,red,blue,red,blue,red,blue,red],
               [red,blue,red,blue,red,blue,red,blue],
               [blue,red,blue,red,blue,red,blue,red],
               [red,blue,red,blue,red,blue,red,blue],
               [blue,red,blue,red,blue,red,blue,red],
               [red,blue,red,blue,red,blue,red,blue]
              ]).

% display board
display_board([H|T], R) :- 
        % how to display 1st line border?
        write('    '), write('   ----------------------------------------------------------------- '), nl,
        write('    '), display_empty_line([]),
        write('   '), write(R), display_line(H), nl,
        write('    '), display_empty_line([]),
        R1 is R-1,
        display_board(T,R1).


display_board([],_):-
        write('     '), write('  ----------------------------------------------------------------- '), nl, nl,
        write('     '), write('      A       B       C       D       E       F       G       H       '), nl.

% display line
display_line([H|T]) :-
        symbol(H,S),
        write('   |   '), write(S), 
        display_line(T).
display_line([]) :-
        write('   |   ').

%display empty line
display_empty_line([]):-
        write('   '), write('|'),write('       '),
        write('|'), write('       '), write('|'),
        write('       '), write('|'), write('       '),
        write('|'), write('       '), write('|'), write('       '),
        write('|'), write('       '), write('|'), write('       '),
        write('|'), nl.

% symbols
symbol(red,'x').
symbol(blue,'o').
symbol(empty,' ').