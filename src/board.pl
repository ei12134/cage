% container
board([[blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue]]).

% display board
display_board([H|T]) :- 
        % how to display 1st line border?
        display_line(H), nl, write(' --------------------------------- '), nl,
        display_board(T),
        display_board([]).

% display line
display_line([H|T]) :-
        symbol(H,S),
        write(' | '), write(S), 
        display_line(T).
display_line([]) :-
        write(' | ').

% symbols
symbol(red,'R').
symbol(blue,'B').
symbol(empty,' ').