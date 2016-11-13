computer_play(0, Game, ModifiedGame):-     
        get_player_turn(Game, Player),
        get_board(Game, Board),
        get_force_jump(Game,ForceMode),
        repeat,
        (
           ForceMode == forceJump ->  get_force_starting_row(Game,StartRandRow), get_force_starting_col(Game,StartRandCol);

           random(0,8,StartRandRow),
           random(0,8,StartRandCol),
           get_matrix_element(StartRandRow,StartRandCol,Board,BoardPiece),
           piece_owned_by(BotPiece,Player),
           BoardPiece == BotPiece
        ),

        check_move_availability(StartRandRow, StartRandCol, Player, Board, DestRow, DestCol), !,

        get_force_jump(Game,ForceMode),
        (       ForceMode == forceJump -> write('A jumping move is mandatory'), nl,
                                          get_enemy_piece(Player, EnemyPiece),
                                          validate_cell_contents(DestRow, DestCol, Board, EnemyPiece);
                ForceMode == noForceJump
        ),
        make_move(StartRandRow, StartRandCol, DestRow, DestCol, Game, ModifiedGame), !.