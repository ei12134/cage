validate_force_jump(DestRow, DestCol, Game):-
        get_player_turn(Game, Player),
        get_board(Game, Board),
        get_force_jump(Game,ForceMode),
        (       ForceMode == forceJump -> write('A jumping move is mandatory'), nl,
                                          get_enemy_piece(Player, EnemyPiece),
                                          validate_cell_contents(DestRow, DestCol, Board, EnemyPiece);
                ForceMode == noForceJump;
                fail
        ),!.

computer_play(0, Game, ModifiedGame):-     
        get_player_turn(Game, Player),
        get_board(Game, Board),
        get_force_jump(Game,ForceMode),
        repeat,
        (
           ForceMode == forceJump -> get_force_starting_row(Game,StartRandRow), get_force_starting_col(Game,StartRandCol);

           random(0,8,StartRandRow),
           random(0,8,StartRandCol),
           get_matrix_element(StartRandRow,StartRandCol,Board,BoardPiece),
           piece_owned_by(BotPiece,Player),
           BoardPiece == BotPiece
        ),

        check_move_availability(StartRandRow, StartRandCol, Player, Board), !,

        IncRow is StartRandRow + 1,
        DecRow is StartRandRow - 1,
        IncCol is StartRandCol + 1,
        DecCol is StartRandCol - 1,
        repeat,
        random(0, 8, RandomMove),
        (
           (RandomMove =:= 0, validate_force_jump(IncRow,StartRandCol,Game), validate_move(StartRandRow, StartRandCol, IncRow, StartRandCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 1, validate_force_jump(DecRow,StartRandCol,Game), validate_move(StartRandRow, StartRandCol, DecRow, StartRandCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 2, validate_force_jump(StartRandRow,IncCol,Game), validate_move(StartRandRow, StartRandCol, StartRandRow, IncCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 3, validate_force_jump(StartRandRow,DecCol,Game), validate_move(StartRandRow, StartRandCol, StartRandRow, DecCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 4, validate_force_jump(IncRow,IncCol,Game), validate_move(StartRandRow, StartRandCol, IncRow, IncCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 5, validate_force_jump(DecRow,DecCol,Game), validate_move(StartRandRow, StartRandCol, DecRow, DecCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 6, validate_force_jump(DecRow,IncCol,Game), validate_move(StartRandRow, StartRandCol, DecRow, IncCol, Player, Board, DestRow, DestCol));
           (RandomMove =:= 7, validate_force_jump(IncRow,DecCol,Game), validate_move(StartRandRow, StartRandCol, IncRow, DecCol, Player, Board, DestRow, DestCol));
           fail
        ), make_move(StartRandRow, StartRandCol, DestRow, DestCol, Game, ModifiedGame), !.