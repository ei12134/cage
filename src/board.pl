% cell contents
cell(red).
cell(blue).
cell(empty).

% symbols
symbol(red,'x').
symbol(blue,'o').
symbol(empty,' ').

get_cell_symbol(empty,' ').
get_cell_symbol(red,'x').
get_cell_symbol(blue,'o').

piece_owned_by(red,redPlayer).
piece_owned_by(blue,bluePlayer).

get_board_cell(0,Col,[HeadList|_],Symbol):-
        get_list_element(Col,HeadList,Symbol).

get_board_cell(Row,Col,[_|TailList], Symbol):-
        Row > 0,
        Row1 is Row - 1,
        get_board_cell(Row1,Col,TailList,Symbol).

% checks if both players have pieces on the board
validate_board_pieces(Game):-
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

% test board
test_board([[empty,empty,empty,empty,empty,red,empty,empty],
            [empty,empty,empty,empty,empty,blue,empty,empty],
            [empty,empty,empty,empty,empty,empty,empty,empty],
            [empty,empty,red,blue,empty,empty,empty,empty],
            [empty,empty,empty,blue,red,empty,empty,empty],
            [red,empty,empty,empty,empty,empty,empty,empty],
            [blue,empty,empty,empty,empty,red,empty,empty],
            [empty,empty,empty,empty,empty,empty,empty,empty]
           ]).

% display board
display_board([H|T], R) :- 
        % how to display 1st line border?
        write('    '), write('   ----------------------------------------------------------------- '), nl,
        write('    '), display_empty_line([]),
        write('   '), write(R), display_line(H), nl,
        write('    '), display_empty_line([]),
        R1 is R - 1,
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