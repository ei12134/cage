:-include('cage.pl').

% moves
centering_move(row,col,dest_row,dest_col,board).
adjoining_mode(row,col,dest_row,dest_col,board).
jump(row,col,dest_row,dest_col,board).
restriction_1(row,col,adj_row,adj_col,boad).
restriction_2(row,col,adj_row,adj_col,board).

% not finished (last "invalid move" is not correct)
validateMove(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        validateJump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        validateCentering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        validateAdjoining_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard);
        invalidMove.
        

% validateJump(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        



validateCentering_move(SrcRow,SrcCol, DestRow, DestCol, Board, ResultBoard):-
        %get_board(Game,Board),
        %get_playerTurn(Game,Player),
        
        % check if movement is directional to the center
        DistSrcRow is 3 -SrcRow,
        DistDestRow is 3- DestRow,
        DistSrcRow < DistDestRow -> invalidMove;
        
        
        %check if destCell is not full
        getBoardCell(DestRow,DestCol,Board, Symbol),
        Symbol == empty,
        
        %if everthing is ok move piece
        centering_move(SrcRow,SrcCol,DestRow,DestCol,Board,ResultBoard),!.

invalidMove:-
        write("INVALID MOVE!"), nl,
        write("Press Enter to continue"),nl, fail.