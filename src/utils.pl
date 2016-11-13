get_list_element(0,[HeadElem|_],HeadElem).

get_list_element(Pos,[_|OtherElems],Symbol):-
        Pos > 0,
        Pos1 is Pos-1,
        get_list_element(Pos1,OtherElems,Symbol).

get_matrix_element(0, ElemCol, [ListAtTheHead|_], Elem):-
        get_list_element(ElemCol, ListAtTheHead, Elem).

get_matrix_element(ElemRow, ElemCol, [_|RemainingLists], Elem):-
        ElemRow > 0,
        ElemRow1 is ElemRow-1,
        get_matrix_element(ElemRow1, ElemCol, RemainingLists, Elem).

set_matrix_element(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
        set_list_element(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
set_matrix_element(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
        ElemRow > 0,
        ElemRow1 is ElemRow-1,
        set_matrix_element(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

set_list_element(0, Elem, [_|L], [Elem|L]).
set_list_element(I, Elem, [H|L], [H|ResL]):-
        I > 0,
        I1 is I-1,
        set_list_element(I1, Elem, L, ResL).

initialize_random_seed:-
        now(Usec), Seed is Usec mod 30269,
        getrand(random(X, Y, Z, _)),
        setrand(random(Seed, X, Y, Z)), !.