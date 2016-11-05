% includes
:- use_module(library(random)).
:- use_module(library(system)).
:- include('cli.pl').
:- include('logic.pl').
:- include('board.pl').

% program starting point
cage :- main_menu.

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
        getInteger(R), getInteger(C), get_code(_), Row is R-1, Col is C-49.

getInteger(Input):-
        get_code(Temp),
        Input is Temp-48.

