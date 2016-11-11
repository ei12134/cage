input_coords(Row,Col):-
        % get_code(_) discards the enter
        get_integer(R), get_integer(C), get_code(_), Row is R-1, Col is C-49.

get_integer(Input):-
        get_code(Temp),
        Input is Temp-48.

main_menu:-
        print_menu,
        get_character(Input),
        (
           Input = '1' -> hvh(Game), start(Game);
           %           Char = '2' -> hvc(Game), start(Game);
           %           Char = '3' -> hvc(Game), start(Game);
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