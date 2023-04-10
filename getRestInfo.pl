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

get_num_of_restaurant(Dict, ReturnedResult) :-
    get_Businesses_Dict(Dict, ListOfBusiness),
    get_all_restaurant_info(ListOfBusiness, ReturnedResult).

get_first_restaurant_info(ListOfBusiness, ReturnedResult) :-
    get_first(ListOfBusiness, Restaurant),
    retrieveInfo(Restaurant, ReturnedResult).
    
get_all_restaurant_info(ListOfBusiness, ReturnedResult) :-
    member(Restaurant, ListOfBusiness),
    retrieveInfo(Restaurant, ReturnedResult).

get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

get_info(SingleRestaurant, PropertyName, JSONProperty, [], [AddInfo]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo), !.

get_info(SingleRestaurant, PropertyName, JSONProperty, RestaurantInfoList, [AddInfo | RestaurantInfoList]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo).

retrieveInfo(Restaurant, ReturnedResult) :-
    call(get_info, Restaurant, 'Rating', 'rating', [], R),
    call(get_info, Restaurant, 'Website', 'url', R, R1),
    call(get_info, Restaurant, 'Phone no.', 'phone', R1, R2),
    call(get_info, Restaurant, 'Name', 'name', R2, ReturnedResult).

get_first([E], E).
get_first([H|_], H).

get_next([E], E, []).
get_next([H|T], H, T).