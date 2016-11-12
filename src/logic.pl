% moves
%centering_move(row,col,dest_row,dest_col,board).
%adjoining_mode(row,col,dest_row,dest_col,board).
%jump(row,col,dest_row,dest_col,board).
%restriction_1(row,col,adj_row,adj_col,boad).
%restriction_2(row,col,adj_row,adj_col,board).

% not finished (last "invalid move" is not correct)
make_move(SrcRow,SrcCol, DestRow, DestCol,Game, ModifiedGame):-
        make_jump(SrcRow,SrcCol, DestRow, DestCol, Game, ModifiedGame), !
%        make_centering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
%        make_adjoining_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
.

make_jump(SrcRow, SrcCol, DestRow, DestCol, Game, ModifiedGame):- 
        get_board(Game,Board), 
        get_player_turn(Game,Player),
        validate_jump(SrcRow, SrcCol, DestRow, DestCol, Player, Board), !.

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

validate_jump(SrcRow, SrcCol, DestRow, DestCol, Player, Board):-
        % selected destiny cell must contain an opponent piece
        (
           Player == redPlayer -> validate_cell_contents(DestRow, DestCol, Board, blue);
           Player == bluePlayer -> validate_cell_contents(DestRow, DestCol, Board, red)
        ),

        % we first need to know if the jump is horizontal or vertical
        % get the destiny empty cell coordinates
        % real destiny cell must be empty
        get_jump_type(SrcRow, SrcCol, DestRow, DestCol, JumpType),
        get_jump_destiny_cell_coordinates(SrcRow, SrcCol, DestRow, DestCol, JumpType, EmptyCellRow, EmptyCellCol),
        validate_cell_contents(EmptyCellRow, EmptyCellCol, Board, empty), !.

%% validate horizontal movement
%DeltaCol is abs(DestCol - SrcCol),
%(DeltaCol =:= 0; DeltaCol =:= 2),
%
%% check if destiny cell is empty
%getMatrixElemAt(DestRow, DestCol, Board, Cell),
%Cell == emptyCell,
%
%% check if cell between source and destiny is friendly
%MiddleCellRow is SrcRow + DeltaRow // 2,
%MiddleCellCol is SrcCol + (DestCol - SrcCol) // 2,
%getMatrixElemAt(MiddleCellRow, MiddleCellCol, Board, MiddleCell),
%(
%Player == whitePlayer -> MiddleCell == whiteCell;
%Player == blackPlayer -> MiddleCell == blackCell
%).

get_jump_type(SrcRow, SrcCol, DestRow, DestCol, JumpType):-
        (
           SrcRow == DestRow -> JumpType = horizontal;
           SrcCol == DestCol -> JumpType = vertical
        ).

validate_centering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        %get_board(Game,Board),
        %get_playerTurn(Game,Player),

        % check if movement is directional to the center
        DistSrcRow is 3 - SrcRow,
        DistDestRow is 3 - DestRow,
        DistSrcRow < DistDestRow -> invalid_move;

        % check if destiny cell is empty
        get_board_cell(DestRow,DestCol,Board, Symbol),
        Symbol == empty,

        % if everthing is ok move piece
        move_piece(SrcRow, SrcCol, DestRow, DestCol, Board, ResultBoard), !.

validate_source_to_destiny_delta(SrcRow, SrcCol, DestRow, DestCol):-
        DeltaRow is abs(DestRow - SrcRow),
        DeltaCol is abs(DestCol - SrcCol),
        (
           DeltaRow == 0 -> DeltaCol == 1;
           DeltaCol == 0 -> DeltaRow == 1
        ),!.

validate_source_to_destiny_delta(_, _, _, _):-
        write('Invalid destiny cell distance delta!'), nl,
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