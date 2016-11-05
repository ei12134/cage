% container
initial_board([[blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue],
       [blue,red,blue,red,blue,red,blue,red],
       [red,blue,red,blue,red,blue,red,blue]
      ]).

% display board
display_board([H|T], R) :- 
        % how to display 1st line border?
        write('    '), write('   ----------------------------------------------------------------- '), nl,
        write('    '), display_empty_line([]),
        write('   '), write(R), display_line(H), nl,
        write('    '), display_empty_line([]),
        R1 is R-1,
        display_board(T,R1).


display_board([],_):-
        write('     '), write('  ----------------------------------------------------------------- '), nl, nl,
        write('     '), write('      A       B       C       D       E       F       G       H       '), nl.

% display line
display_line([H|T]) :-
        symbol(H,S),
        write('   |   '), write(S), 
        display_line(T).
display_line([]) :-
        write('   |   ').

%display empty line
display_empty_line([]):-
        write('   '), write('|'),write('       '),
        write('|'), write('       '), write('|'),
        write('       '), write('|'), write('       '),
        write('|'), write('       '), write('|'), write('       '),
        write('|'), write('       '), write('|'), write('       '),
        write('|'), nl.

% symbols
symbol(red,'x').
symbol(blue,'o').
symbol(empty,' ').