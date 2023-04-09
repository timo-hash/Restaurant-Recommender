:- [api].

haveResultsJSON.
noResultsJSON.

%% used to determine if there are any item in the response JSON object
check_any_results_returned(Dict, HaveResult) :-
    NumberOfItems = Dict.get('total'),
    more_than_0(NumberOfItems, HaveResult).

more_than_0(X, hasResultsJSON) :-
    X > 0, !.
more_than_0(_, noResultsJSON).

% get_first_restaurant_info(Dict, Property, ReturnedResult) :-
%     get_Businesses_Dict(Dict, ListOfBusiness),
%     get_first(ListOfBusiness, Restaurant),
%     call(Property, Restaurant, ReturnedResult).

get_first_restaurant_info(Dict, ReturnedResult) :-
    get_Businesses_Dict(Dict, ListOfBusiness),
    get_first(ListOfBusiness, Restaurant),
    call(get_info, Restaurant, 'Rating', 'rating', [], R),
    call(get_info, Restaurant, 'Phone no.', 'phone', R, R1),
    call(get_info, Restaurant, 'Website', 'url', R1, R2),
    call(get_info, Restaurant, 'Name', 'name', R2, ReturnedResult).

% get_all_restaurant_info(Dict, Property, ReturnedResult) :-
%     get_Businesses_Dict(Dict, ListOfBusiness),
%     get_first(ListOfBusiness, Restaurant),
%     call(Property, Restaurant, ReturnedResult).

get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

get_price(SingleRestaurant) :-
    Price = SingleRestaurant.get('price'),
    write('Price: '), write(Price), nl.

get_info(SingleRestaurant, PropertyName, JSONProperty, RestaurantInfoList, [AddInfo | RestaurantInfoList]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo),
    write(AddInfo),
    !.

get_info(SingleRestaurant, PropertyName, JSONProperty, [], [AddInfo]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo),
    write(AddInfo).


get_first([H|_], H).
get_first([E], E).

% my_map([H|_], H)