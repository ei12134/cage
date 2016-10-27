% moves
centering_move(row,col,dest_row,dest_col,board).
adjoining_mode(row,col,dest_row,dest_col,board).
jump(row,col,dest_row,dest_col,board).
restriction_1(row,col,adj_row,adj_col,boad).
restriction_2(row,col,adj_row,adj_col,board).

% not finished
validateMove(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        validateCentering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        validateAdjoining_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        validateJump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        invalidMove.

invalidMove:-
        write("INVALID MOVE!"), nl,
        write("Press Enter to continue"),nl, fail.