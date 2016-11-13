% attempt to make a move
make_move(SrcRow,SrcCol, DestRow, DestCol, Game, ModifiedGame):-
        (       
           nl, write('Attempting to make a jump move...'), nl,
           make_jump(SrcRow,SrcCol, DestRow, DestCol, Game, TemporaryGame);

           write('Failed to make a jump move!'), nl, nl,
           write('Attempting to make an adjoining move...'), nl,
           make_adjoining_move(SrcRow,SrcCol, DestRow, DestCol, Game, TemporaryGame);

           write('Failed to make an adjoining move!'), nl, nl,
           write('Attempting to make a centering move...'), nl,
           make_centering_move(SrcRow,SrcCol, DestRow, DestCol, Game, TemporaryGame);

           write('Failed to make a centering move!'), nl, nl,
           get_board(Game, Board), get_player_turn(Game, Player),
           check_move_availability(SrcRow, SrcCol, Player, Board), ModifiedGame = Game;

           write('No valid moves were available -> Switching player turn!'), nl, nl,
           change_player_turn(Game,ModifiedGame), true
        ),
        get_force_jump(TemporaryGame, ForceJumpMode),
        (
           ForceJumpMode == noForceJump -> change_player_turn(TemporaryGame,ModifiedGame),! ;
           ModifiedGame = TemporaryGame
        ).

move_piece(SrcRow, SrcCol, DestRow, DestCol, Board, ModifiedBoard):-
        get_matrix_element(SrcRow,SrcCol,Board,SrcElem),
        set_matrix_element(SrcRow,SrcCol,empty,Board,TemporaryBoard),
        set_matrix_element(DestRow,DestCol,SrcElem,TemporaryBoard,ModifiedBoard).

make_centering_move(SrcRow,SrcCol, DestRow, DestCol, Game, ModifiedGame):-
        get_board(Game,Board),
        get_player_turn(Game, Player),
        validate_centering_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board),
        move_piece(SrcRow, SrcCol, DestRow, DestCol, Board, ModifiedBoard),
        set_board(ModifiedBoard, Game, ModifiedGame).

make_adjoining_move(SrcRow,SrcCol, DestRow, DestCol, Game, ModifiedGame):-
        get_board(Game,Board), 
        get_player_turn(Game,Player),
        validate_adjoining_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board),
        move_piece(SrcRow, SrcCol, DestRow, DestCol, Board, ModifiedBoard),
        set_board(ModifiedBoard, Game, ModifiedGame).

make_jump(SrcRow, SrcCol, DestRow, DestCol, Game, ModifiedGame):- 
        get_board(Game,Board), 
        get_player_turn(Game,Player),
        validate_jump(SrcRow, SrcCol, DestRow, DestCol, Player, Board, JumpDestinyRow, JumpDestinyCol),
        capture_piece(SrcRow, SrcCol, DestRow, DestCol, JumpDestinyRow, JumpDestinyCol, Game, TemporaryGame),
        get_board(TemporaryGame,ModifiedBoard), 
        (
           JumpDestinyRow >= 0,
           JumpDestinyRow =< 7,
           JumpDestinyCol >= 0,
           JumpDestinyCol =< 7,
           validate_force_jump(DestRow, DestCol, JumpDestinyRow, JumpDestinyCol, Player, ModifiedBoard),
           set_force_jump(forceJump, JumpDestinyRow, JumpDestinyCol, TemporaryGame, ModifiedGame),
           write('Jumping move will be forced next turn.'), nl, nl;

           set_force_jump(noForceJump, 0, 0, TemporaryGame, ModifiedGame),
           write('Jumping move is not forced in the next turn.'), nl, nl
        ), !.

capture_piece(SrcRow, SrcCol, DestRow, DestCol, JumpDestinyRow, JumpDestinyCol, Game, ModifiedGame):-
        % get current board
        get_board(Game, Board),

        % empty the captured piece cell
        get_matrix_element(DestRow, DestCol, Board, RemovedCapturedPiece),
        set_matrix_element(DestRow, DestCol, empty, Board, TemporaryBoard),
        dec_piece(RemovedCapturedPiece,Game,TemporaryGame),

        (
           % piece jumped out of the board -> clean two pieces 
           (JumpDestinyRow < 0 ; JumpDestinyRow > 7 ; JumpDestinyCol < 0 ; JumpDestinyCol > 7) ->  get_matrix_element(SrcRow, SrcCol, TemporaryBoard, RemovedPiece),
                                                                                                   set_matrix_element(SrcRow, SrcCol, empty, TemporaryBoard, ModifiedBoard),
                                                                                                   dec_piece(RemovedPiece,TemporaryGame,TemporaryGame2),
                                                                                                   set_board(ModifiedBoard, TemporaryGame2, ModifiedGame);

           (JumpDestinyRow >= 0, JumpDestinyRow =< 7, JumpDestinyCol =< 7, JumpDestinyCol >= 0) -> move_piece(SrcRow, SrcCol, JumpDestinyRow, JumpDestinyCol, TemporaryBoard, ModifiedBoard),
                                                                                                   set_board(ModifiedBoard, TemporaryGame, ModifiedGame)
        ).



get_jump_destiny_cell_coordinates(SrcRow, SrcCol, DestRow, DestCol, JumpType, EmptyCellRow, EmptyCellCol):-
        DeltaRow is DestRow - SrcRow,
        DeltaCol is DestCol - SrcCol,
        (
           JumpType == horizontal -> 
           (
              (DeltaCol > 0) -> EmptyCellCol is DestCol + 1, EmptyCellRow is SrcRow;
              (DeltaCol < 0) -> EmptyCellCol is DestCol - 1, EmptyCellRow is SrcRow
           );
           JumpType == vertical -> 
           (
              (DeltaRow > 0) -> EmptyCellRow is DestRow + 1, EmptyCellCol is SrcCol;
              (DeltaRow < 0) -> EmptyCellRow is DestRow - 1, EmptyCellCol is SrcCol
           )
        ),!.

validate_adjoining_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board):-
        get_enemy_piece(Player,EnemyPiece),
        validate_ortogonal_adjancencies(SrcRow, SrcCol, SrcRow, SrcCol, EnemyPiece, Board),!,
        \+validate_ortogonal_adjancencies(SrcRow, SrcCol, DestRow, DestCol, EnemyPiece, Board), !.

validate_jump(SrcRow, SrcCol, DestRow, DestCol, Player, Board, JumpDestinyRow, JumpDestinyCol):-
        % selected destiny cell must contain an opponent piece
        (
           Player == redPlayer -> validate_cell_contents(DestRow, DestCol, Board, blue);
           Player == bluePlayer -> validate_cell_contents(DestRow, DestCol, Board, red)
        ),

        % we first need to know if the jump is horizontal or vertical
        % get the destiny empty cell coordinates
        % real destiny cell must be empty
        get_jump_type(SrcRow, SrcCol, DestRow, DestCol, JumpType),
        get_jump_destiny_cell_coordinates(SrcRow, SrcCol, DestRow, DestCol, JumpType, JumpDestinyRow, JumpDestinyCol),

        (
           (JumpDestinyRow >= 0, JumpDestinyRow =< 7, JumpDestinyCol >= 0, JumpDestinyCol =< 7) -> validate_cell_contents(JumpDestinyRow, JumpDestinyCol, Board, empty),
                                                                                                   piece_owned_by(Piece,Player),
                                                                                                   validate_ortogonal_adjancencies(DestRow, DestCol, JumpDestinyRow, JumpDestinyCol, Piece, Board);
           true
        ), !.

validate_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board, ValidDestRow, ValidDestCol):-
        validate_jump(SrcRow, SrcCol, DestRow, DestCol, Player, Board, _, _) -> ValidDestRow = DestRow, ValidDestCol = DestCol;
        validate_force_jump_cell_contents(DestRow, DestCol, Board, empty), validate_adjoining_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board) -> ValidDestRow = DestRow, ValidDestCol = DestCol;
        validate_force_jump_cell_contents(DestRow, DestCol, Board, empty), validate_centering_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board) -> ValidDestRow = DestRow, ValidDestCol = DestCol,!.

check_move_availability(SrcRow, SrcCol, Player, Board):-
        % a move must be checked in all directions
        IncRow is SrcRow + 1,
        DecRow is SrcRow - 1,
        IncCol is SrcCol + 1,
        DecCol is SrcCol - 1,
        (
           IncRow =< 7, validate_move(SrcRow, SrcCol, IncRow, SrcCol, Player, Board, _, _);
           DecRow >= 0, validate_move(SrcRow, SrcCol, DecRow, SrcCol, Player, Board, _, _);
           IncCol =< 7, validate_move(SrcRow, SrcCol, SrcRow, IncCol, Player, Board, _, _);
           DecCol >= 0, validate_move(SrcRow, SrcCol, SrcRow, DecCol, Player, Board, _, _);
           DecRow >= 0, DecCol >= 0, validate_move(SrcRow, SrcCol, DecRow, DecCol, Player, Board, _, _);
           IncRow =< 7, IncCol =< 7, validate_move(SrcRow, SrcCol, IncRow, IncCol, Player, Board, _, _);
           DecRow >= 0, IncCol =< 7, validate_move(SrcRow, SrcCol, DecRow, IncCol, Player, Board, _, _);
           IncRow =< 7, DecCol >= 0, validate_move(SrcRow, SrcCol, IncRow, DecCol, Player, Board, _, _)
        ), !.

get_jump_type(SrcRow, SrcCol, DestRow, DestCol, JumpType):-
        (
           SrcRow == DestRow -> JumpType = horizontal;
           SrcCol == DestCol -> JumpType = vertical
        ).

validate_force_jump(CapturedRow, CapturedCol, JumpDestinyRow, JumpDestinyCol, Player, Board):-
        piece_owned_by(PlayerPiece,Player),
        get_enemy_piece(Player,EnemyPiece),
        IncRow is JumpDestinyRow + 1,
        DecRow is JumpDestinyRow - 1,
        IncCol is JumpDestinyCol + 1,
        DecCol is JumpDestinyCol - 1,!,
        (
           (IncRow =< 7, validate_force_jump_cell_contents(IncRow, JumpDestinyCol, Board, EnemyPiece),
            IncRow2 is IncRow + 1,
            (
               IncRow2 =<7 ->(
                                validate_force_jump_cell_contents(IncRow2, JumpDestinyCol, Board, empty),
                                validate_ortogonal_adjancencies(CapturedRow, CapturedCol, IncRow2, JumpDestinyCol, PlayerPiece, Board)
                             );
               true
            )
           );

           (DecRow >= 0, validate_force_jump_cell_contents(DecRow, JumpDestinyCol, Board, EnemyPiece),
            DecRow2 is DecRow - 1,
            (
               DecRow2 >= 0 -> (
                                  validate_force_jump_cell_contents(DecRow2, JumpDestinyCol, Board, empty),
                                  validate_ortogonal_adjancencies(CapturedRow, CapturedCol, DecRow2, JumpDestinyCol, PlayerPiece, Board)
                               ); 
               true
            )
           );

           (IncCol =< 7, validate_force_jump_cell_contents(JumpDestinyRow, IncCol, Board, EnemyPiece),
            IncCol2 is IncCol + 1,
            (
               IncCol2 =< 7 -> (
                                  validate_force_jump_cell_contents(JumpDestinyRow, IncCol2, Board, empty),
                                  validate_ortogonal_adjancencies(CapturedRow, CapturedCol, JumpDestinyRow, IncCol2, PlayerPiece, Board)
                               );
               true
            )
           );

           (DecCol >= 0, validate_force_jump_cell_contents(JumpDestinyRow, DecCol, Board, EnemyPiece),
            DecCol2 is DecCol - 1,
            (
               DecCol2 >= 0 -> (
                                  validate_force_jump_cell_contents(JumpDestinyRow, DecCol2, Board, empty),
                                  validate_ortogonal_adjancencies(CapturedRow, CapturedCol, JumpDestinyRow, DecCol2, PlayerPiece, Board)
                               );
               true
            )
           )
        ).

validate_centered(SrcRow,SrcCol):-
        SrcRow == 3 -> (SrcCol == 4; SrcCol == 3);
        SrcRow == 4 -> (SrcCol == 4; SrcCol == 3);
        fail.

get_quadrant(SrcRow,SrcCol,Quadrant):-
        SrcRow >=0, SrcRow =< 3, SrcCol >= 0, SrcCol =< 3 -> Quadrant = 1;
        SrcRow >=0, SrcRow =< 3, SrcCol >= 4, SrcCol =< 7 -> Quadrant = 2;
        SrcRow >=4, SrcRow =< 7, SrcCol >= 0, SrcCol =< 3 -> Quadrant = 3;
        SrcRow >=4, SrcRow =< 7, SrcCol >= 4, SrcCol =< 7 -> Quadrant = 4.

validate_centering_move(SrcRow, SrcCol, DestRow, DestCol, Player, Board):-
        \+ validate_centered(SrcRow,SrcCol), !, 
        piece_owned_by(PlayerPiece, Player), !,
        validate_ortogonal_adjancencies(SrcRow, SrcCol, DestRow, DestCol, PlayerPiece, Board),
        get_quadrant(SrcRow,SrcCol,Quadrant),
        DestRow >= 0, DestRow =< 7,
        DestCol >= 0, DestCol =< 7,
        DeltaRow is DestRow - SrcRow,
        DeltaCol is DestCol - SrcCol,
        (
           Quadrant == 1 -> (
                               DeltaRow > 0, DeltaCol >= 0;
                               DeltaCol > 0, DeltaRow >= 0
                            );
           Quadrant == 2 -> (
                               DeltaRow > 0, DeltaCol =< 0;
                               DeltaCol < 0, DeltaRow >= 0
                            );
           Quadrant == 3 -> (
                               DeltaRow < 0, DeltaCol >= 0;
                               DeltaCol > 0, DeltaRow =< 0
                            );
           Quadrant == 4 -> (
                               DeltaRow < 0, DeltaCol =< 0;
                               DeltaCol < 0, DeltaRow =< 0
                            )
        ),!.

validate_ortogonal_adjancencies(SrcRow, SrcCol, DestRow, DestCol, AvoidPiece, Board):-   
        IncRow is DestRow + 1,
        DecRow is DestRow - 1,
        IncCol is DestCol + 1,
        DecCol is DestCol - 1, !,
        (       
           SrcRow \== IncRow -> (validate_ortogonal_cell_contents(IncRow, DestCol, Board, AvoidPiece),!);
           true
        ),
        (       
           SrcRow \== DecRow -> ( validate_ortogonal_cell_contents(DecRow, DestCol, Board, AvoidPiece),!);
           true
        ),
        (       
           SrcCol \== IncCol -> (validate_ortogonal_cell_contents(DestRow, IncCol, Board, AvoidPiece),!);
           true
        ),
        (       
           SrcCol \== DecCol -> (validate_ortogonal_cell_contents(DestRow, DecCol, Board, AvoidPiece),!);
           true
        ),!.

validate_ortogonal_adjancencies(_, _, _, _, _, _):-
        write('Destiny cell with bad ortogonal adjacency!'), nl,
        fail.

validate_source_to_destiny_delta(SrcRow, SrcCol, DestRow, DestCol):-
        DeltaRow is abs(DestRow - SrcRow),
        DeltaCol is abs(DestCol - SrcCol),
        DeltaRow =< 1, DeltaCol =< 1,!.

validate_source_to_destiny_delta(_, _, _, _):-
        write('Invalid destiny cell distance delta!'), nl,
        fail.

validate_ortogonal_cell_contents(Row, Col, Board, ExpectedContent):-
        (
           (Row >= 0, Row =< 7, Col >= 0, Col =< 7) -> (get_matrix_element(Row, Col, Board, Piece),
                                                        Piece \= ExpectedContent, !);
           true
        ), !.

validate_ortogonal_cell_contents(_, _, _, _):-
        fail.

validate_force_jump_cell_contents(Row, Col, Board, ExpectedContent):-
        get_matrix_element(Row, Col, Board, Piece),
        Piece == ExpectedContent, !.

validate_force_jump_cell_contents(_, _, _, _):-
        fail.

validate_cell_contents(Row, Col, Board, ExpectedContent):-
        get_matrix_element(Row, Col, Board, Piece),
        Piece == ExpectedContent, !.

validate_cell_contents(_, _, _, _):-
        write('Invalid cell content type'), nl,
        fail.

validate_destiny_cell_type(Row, Col, Board, Player):-
        get_matrix_element(Row, Col, Board, Piece),
        \+ piece_owned_by(Piece, Player), !.
%        piece_owned_by(NormalPiece, Player),
%        Piece \= NormalPiece, !.

validate_destiny_cell_type(_, _, _, _):-
        write('Invalid destiny cell content type!'), nl,
        fail.

validate_piece_owner(Row, Col, Board, Player):-
        get_matrix_element(Row, Col, Board, Piece),
        piece_owned_by(Piece, Player), !.

validate_piece_owner(_, _, _, _):-
        write('Invalid piece!'), nl,
        fail.

invalid_move:-
        write('Invalid move!'), nl, fail.