get_moving_piece_source_coordinates(SrcRow, SrcCol):-
        write('Enter the column and row (Ex: a1) of the piece to move followed by <CR>: '), nl,
        get_coordinates(SrcRow,SrcCol), nl.

get_piece_destiny_coordinates(DstRow, DstCol):-
        write('Enter the destiny column and row (Ex: a1) of the piece to move followed by <CR>:'), nl,
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

display_turn_info(Game):-
        get_player_turn(Game, Player),
        get_player_name(Player, PlayerName),
        get_evaluation(Game, Player, Evaluation),
        nl, write(PlayerName), write(' game evaluation: '), write(Evaluation), nl,
        write(PlayerName), write(' player\'s turn to play.'), !.

main_menu:-
        print_menu,
        get_char(Input),
        get_char(_),
        (
           Input == '1' -> human_vs_human(Game), game_loop(Game);
           Input == '2' -> human_vs_computer(Game), game_loop(Game);
           Input == '3' -> computer_vs_computer(Game), game_loop(Game);
           main_menu
        ).

print_menu:-
        write('        Cage game'), nl, nl,
        write('  [1] Human vs. Human'), nl,
        write('  [2] Human vs. Computer'), nl,
        write('  [3] Computer vs. Computer'), nl, nl,
        write('Enter game mode number:'), nl.