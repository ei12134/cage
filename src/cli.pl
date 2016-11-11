get_moving_piece_source_coordinates(SrcRow, SrcCol):-
        write('Enter the row and column of the piece you want to move followed by <CR>: '), nl,
        get_coordinates(SrcRow,SrcCol), nl.

get_piece_destiny_coordinates(DstRow, DstCol):-
        write('Enter the destiny row and column of the piece you want to move followed by <CR>:'), nl,
        get_coordinates(DstRow,DstCol), nl.

get_integer(Input):-
        get_code(TempInput),
        Input is TempInput - 48.

get_return_key:-
        get_code(_).

get_coordinates(Row,Col):-
        get_integer(C),
        get_integer(R),
        get_return_key,
        Row is 8-R,
        Col is C-49.

display_turn_info(Player):-
        get_player_name(Player, PlayerName),
        write('\n'), write(PlayerName), write(' player\'s turn to play.'), !.

main_menu:-
        print_menu,
        get_char(Input),
        get_char(_),
        (
           Input == '1' -> hvh(Game), game_loop(Game);
           %           Char = '2' -> hvc(Game), start(Game);
           %           Char = '3' -> cvc(Game), start(Game);
           main_menu
        ).

print_menu:-
        write('        Cage game'), nl, nl,
        write('  [1] Player vs. Player'), nl,
        write('  [2] Player vs. Computer'), nl,
        write('  [3] Computer vs. Computer'), nl, nl,
        write('Enter game mode number:'), nl.