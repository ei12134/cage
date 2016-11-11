get_moving_piece_source_coordinates(SrcRow, SrcCol):-
        write('Enter the row and column of the piece you want to move followed by <CR>: '), nl,
        read_input_coordinates(SrcRow,SrcCol), nl.

get_piece_destiny_coordinates(DstRow, DstCol):-
        write('Enter the destiny row and column of the piece you want to move followed by <CR>:'), nl,
        read_input_coordinates(DstRow,DstCol), nl.

read_input_coordinates(Row,Col):-
        get_integer(C),
        get_integer(R),
        discard_input(_),
        Row is 8-R, Col is C-49.

get_input_code(Input):-
        get_code(TempInput),
        get_code(_),
        Input is TempInput - 48.

get_integer(Input):-
        get_code(Temp),
        Input is Temp - 48.

discard_input(_):-
        get_code(_).

display_turn_info(Player):-
        get_player_name(Player, PlayerName),
        write('\n'), write(PlayerName), write(' player\'s turn to play.'), !.

main_menu:-
        print_menu,
        get_character(Input),
        (
           Input = '1' -> hvh(Game), game_loop(Game);
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

get_character(Input):-
        get_char(Input),
        get_char(_).