main_menu:-
        printgameModeMenu,
        get_character(Input),
        (
           Input = '1' -> hvh(Game), start(Game);
           %           Char = '2' -> hvc(Game), start(Game);
           %           Char = '3' -> hvc(Game), start(Game);
           main_menu
        ).

printgameModeMenu:-
        write('        Cage game'), nl, nl,
        write('  [1] Player vs. Player'), nl,
        write('  [2] Player vs. Computer'), nl,
        write('  [3] Computer vs. Computer'), nl, nl,
        write('Enter game mode number:'), nl.

get_character(Input):-
        get_char(Input),
        get_char(_).