% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('cli.pl').
:- include('logic.pl').
:- include('board.pl').

% program starting point
cage :- main_menu.


%players and pieces
player(redPlayer).
player(bluePlayer).

getPlayerName(redPlayer, 'Red').
getPlayerName(bluePlayer, 'Blue').

get_playerTurn(Game,Player):-
         getListElem(2,Game,Player).

piece(redPiece).
piece(bluePiece).

getCellSymbol(emptyCell,' ').
getCellSymbol(redCell,'x').
getCellSymbol(blueCell,'o').

pieceOwnedBy(redCell,redPlayer).
pieceOwnedBy(blueCell,bluePlayer).

playerOwnesCell(Row,Col,Game):-
        get_board(Game,Board),
        get_playerTurn(Game,Player),
        getBoardCell(Row,Col,Board,Cell),
        pieceOwnedBy(Cell,Player).
                  
% Human vs Human game mode
hvh(Game):-
        initial_board(Board),
        Game = [Board, [32, 32], red, hvh], !.

start(Game) :- get_board(Game, Board), display_board(Board,8).

get_board([Board|_], Board).




% piece input functions 
getPieceSrcCoord(SrcRow, SrcCol):-
        write("Please enter the value of the row and col of the piece you whant to move and press <Enter>"), nl,
        inputCoords(SrcRow,SrcCol), nl.

getPieceDestCoord(DstRow, DstCol):-
        write("Please enter the value of the row and col where you whant to move and press <Enter>"), nl,
        inputCoords(DstRow,DstCol), nl.

inputCoords(Row,Col):-
        % get_code(_) discards the enter
        getInteger(R), getInteger(C), get_code(_), Row is R-1, Col is C-49.

getInteger(Input):-
        get_code(Temp),
        Input is Temp-48.



%pieces functions
getNumPiecesInBoard(Game,ListOfPieces):-
        getListElem(1,Game,ListOfPieces).

getNumRedPieces(Game,NumRedPieces):-
        getNumPiecesInBoard(Game,ListOfPieces),
        getListElem(0,ListOfPieces,NumRedPieces).

getNumBluePieces(Game,NumBluePieces):-
        getNumPiecesInBoard(Game,ListOfPieces),
        getListElem(0,ListOfPieces,NumBluePieces).



%board functions
bothPlayersHavePiecesInBoard(Game):-
        getNumRedPieces(Game,NumRedPieces),
        getNumBluePieces(Game,NumBluePieces),
        NumRedPieces > 0,
        NumBluePieces > 0,!.

%get board Cells 
getBoardCell(0,Col,[HeadList|_],Symbol):-
        getListElem(Col,HeadList,Symbol).

getBoardCell(Row,Col,[_|TailList], Symbol):-
        Row >0,
        Row1 is Row-1,
        getBoardCell(Row1,Col,TailList,Symbol).        

getListElem(0,[HeadElem|_],HeadElem).

getListElem(Pos,[_|OtherElems],Symbol):-
        Pos >0,
        Pos1 is Pos-1,
        getListElem(Pos1,OtherElems,Symbol).
