get_list_element(0,[HeadElem|_],HeadElem).

get_list_element(Pos,[_|OtherElems],Symbol):-
        Pos >0,
        Pos1 is Pos-1,
        get_list_element(Pos1,OtherElems,Symbol).

get_matrix_element(0, ElemCol, [ListAtTheHead|_], Elem):-
        get_list_element(ElemCol, ListAtTheHead, Elem).
get_matrix_element(ElemRow, ElemCol, [_|RemainingLists], Elem):-
        ElemRow > 0,
        ElemRow1 is ElemRow-1,
        get_matrix_element(ElemRow1, ElemCol, RemainingLists, Elem).