get_list_element(0,[HeadElem|_],HeadElem).

get_list_element(Pos,[_|OtherElems],Symbol):-
        Pos >0,
        Pos1 is Pos-1,
        get_list_element(Pos1,OtherElems,Symbol).