% moves
%centering_move(row,col,dest_row,dest_col,board).
%adjoining_mode(row,col,dest_row,dest_col,board).
%jump(row,col,dest_row,dest_col,board).
%restriction_1(row,col,adj_row,adj_col,boad).
%restriction_2(row,col,adj_row,adj_col,board).

% not finished (last "invalid move" is not correct)
validate_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        %        validate_jump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        validate_centering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        %        validate_adjoining_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        invalid_move.


% validate_jump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-


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

invalid_move:-
        write("Invalid move!"), nl, fail.