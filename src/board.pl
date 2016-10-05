% container
board([[blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue]
       ]).

% display board
display_board([H|T]) :- 
        % how to display 1st line border?
        write('   ----------------------------------------------------------------- '), nl,
        display_empty_line([]),
        display_line(H), nl,
        display_empty_line([]),
        display_board(T).

display_board([]):-
        write('   ----------------------------------------------------------------- '), nl.


% display_line([]):- write('      '), nl.

% display line
display_line([H|T]) :-
        symbol(H,S),
        write('   |   '), write(S), 
        display_line(T).
display_line([]) :-
        write('   |   ').

%display empty line
display_empty_line([]):-
        write('   '),
        write('|'), write('       '), write('|'), write('       '), write('|'), write('       '), write('|'),
        write('       '), write('|'), write('       '), write('|'), write('       '), write('|'), 
        write('       '), write('|'), write('       '), write('|'), nl.
        
% symbols
symbol(red,'r').
symbol(blue,'b').
symbol(empty,' ').