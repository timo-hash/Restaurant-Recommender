:- [api].

haveResultsJSON.
noResultsJSON.

%% used to determine if there are any item in the response JSON object
check_any_results_returned(Dict, HaveResult) :-
    NumberOfItems = Dict.get('total'),
    more_than_0(NumberOfItems, HaveResult).

%% return hasResultsJSON if given number > 0, else return noResultsJSON
more_than_0(X, hasResultsJSON) :-
    X > 0, !.
more_than_0(_, noResultsJSON).

get_num_of_restaurant(Dict, ReturnedResult, Num) :-
    get_Businesses_Dict(Dict, ListOfBusiness),
    (Num == 1 ->
        get_first_restaurant_info(ListOfBusiness, ReturnedResult)
        ;
        get_all_restaurant_info(ListOfBusiness, ReturnedResult)
    ).
    

get_first_restaurant_info(ListOfBusiness, ReturnedResult) :-
    get_first(ListOfBusiness, Restaurant),
    retrieveInfo(Restaurant, ReturnedResult).
    
%% get information on all of the restaurants that were returned
get_all_restaurant_info(ListOfBusiness, ReturnedResult) :-
    member(Restaurant, ListOfBusiness),
    retrieveInfo(Restaurant, ReturnedResult).

%% get the business object within the response dictionary
get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

%% given the key, get the value in the restaurant(Dict) and append to a list
get_info(SingleRestaurant, PropertyName, JSONProperty, [], [AddInfo]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo), !.
get_info(SingleRestaurant, PropertyName, JSONProperty, RestaurantInfoList, [AddInfo | RestaurantInfoList]) :-
    RetrievedValue = SingleRestaurant.get(JSONProperty),
    atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo).

%% extract the name, phone #, website and rating of a restaurant(Dict)
retrieveInfo(Restaurant, ReturnedResult) :-
    call(get_info, Restaurant, 'Rating', 'rating', [], R),
    call(get_info, Restaurant, 'Website', 'url', R, R1),
    call(get_info, Restaurant, 'Phone no.', 'phone', R1, R2),
    call(get_info, Restaurant, 'Name', 'name', R2, ReturnedResult).


%% get first item from list
get_first([E], E).
get_first([H|_], H).