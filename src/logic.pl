% moves
%centering_move(row,col,dest_row,dest_col,board).
%adjoining_mode(row,col,dest_row,dest_col,board).
%jump(row,col,dest_row,dest_col,board).
%restriction_1(row,col,adj_row,adj_col,boad).
%restriction_2(row,col,adj_row,adj_col,board).

% not finished (last "invalid move" is not correct)
make_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        make_jump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard)
%        make_centering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
%        make_adjoining_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
.

make_jump(SrcRow, SrcCol, DestRow, DestCol, Board, ResultBoard):-  
        validate_jump(SrcRow, SrcCol, DestRow, DestCol, Board, ResultBoard).


validate_jump(SrcRow, SrcCol, DestRow, DestCol, Board, ResultBoard):-
        get_board(Game,Board),
        get_player_turn(Game,Player),

        % destiny cell must contain an opponent piece
        (
           Player == redPlayer -> validate_cell_contains(DestRow, DestCol, Board, blue);
           Player == bluePlayer -> validate_cell_contains(DestRow, DestCol, Board, red)
        ),

        get_jump_type(SrcRow, SrcCol, DestRow, DestCol, JumpType),

        % we first need to know if the jump is horizontal or vertical
        % get the destiny empty cell coordinates
        DeltaRow is DestRow - SrcRow,
        DeltaCol is DestCol - SrcCol,
        (
           JumpType == horizontal -> (
                                        DeltaRow > 0 -> EmptyCellRow is DestRow + 1;
                                        DeltaRow < 0 -> EmptyCellRow is DestRow - 1
                                     );

           JumpType == vertical ->
           (
              DeltaCol > 0 -> EmptyCellCol is DestCol + 1;
              DeltaCol < 0 -> EmptyCellCol is DestRow - 1
           )
        ).

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
        DistSrcRow is 3 -SrcRow,
        DistDestRow is 3- DestRow,
        DistSrcRow < DistDestRow -> invalid_move;


        % check if destiny cell is empty
        get_board_cell(DestRow,DestCol,Board, Symbol),
        Symbol == empty,

        % if everthing is ok move piece
        move_piece(SrcRow,SrcCol,DestRow,DestCol,Board,ResultBoard),!.

validate_cell_contains(Row, Col, Board, ExpectedContent):-
        get_matrix_element(Row, Col, Board, Piece),
        Piece == ExpectedContent.

validate_cell_contains(_, _, _, _):-
        write('Invalid cell content'), nl,
        fail.

validate_destiny_cell_type(Row, Col, Board, Player):-
        get_matrix_element(Row, Col, Board, Piece),
        \+piece_owned_by(Piece, Player), !.

validate_destiny_cell_type(_, _, _, _):-
        write('Invalid destiny cell!'), nl,
        fail.

validate_piece_owner(Row, Col, Board, Player):-
        get_matrix_element(Row, Col, Board, Piece),
        piece_owned_by(Piece, Player), !.

validate_piece_owner(_, _, _, _):-
        write('Invalid piece!'), nl,
        fail.

invalid_move:-
        write('Invalid move!'), nl, fail.