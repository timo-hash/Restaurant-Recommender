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

get_num_of_restaurant(Dict, RequestParamsList, ReturnedResult) :-
    get_Businesses_Dict(Dict, BusinessList),
    filterListOfBusiness(RequestParamsList, BusinessList, FilteredBusinessList),
    (member(numOfRest(1), RequestParamsList) ->
        get_first_restaurant_info(FilteredBusinessList, ReturnedResult)
        ;
        get_all_restaurant_info(FilteredBusinessList, ReturnedResult)
    ).
    
%% get information on the first restaurant that was returned
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
    %% if key doesn't exist in JSON, then just ignore it
    (get_dict(JSONProperty, SingleRestaurant, _) ->
        RetrievedValue = SingleRestaurant.get(JSONProperty),
        atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo)
        ;
        AddInfo = ""
    ), !.
get_info(SingleRestaurant, PropertyName, JSONProperty, RestaurantInfoList, [AddInfo | RestaurantInfoList]) :-
    %% if key doesn't exist in JSON, then just ignore it
    (get_dict(JSONProperty, SingleRestaurant, _) ->
        RetrievedValue = SingleRestaurant.get(JSONProperty),
        atomic_list_concat([PropertyName, ": ", RetrievedValue], AddInfo)
        ;
        AddInfo = ""
    ).

%% extract the name, phone #, website and rating of a restaurant(Dict)
retrieveInfo(Restaurant, ReturnedResult) :-
    call(get_info, Restaurant, 'Price', 'price', [], R),
    call(get_info, Restaurant, 'Rating', 'rating', R, R1),
    call(get_info, Restaurant, 'Website', 'url', R1, R2),
    call(get_info, Restaurant, 'Phone no.', 'phone', R2, R3),
    call(get_info, Restaurant, 'Name', 'name', R3, ReturnedResult).

%% filters a list of Business objects for certain price and rating
filterListOfBusiness(InputParamList, InputRestList, PriceAndRatingFilteredList) :-
    % filter list for price if possible
    (member(jsonFilter("price", P), InputParamList) ->
        include(check_price(P), InputRestList, PriceFilteredList)
        ;
        PriceFilteredList = InputRestList
    ),

    % filter list for rating if possible
    (member(jsonFilter("rating", R), InputParamList) ->
        include(check_rating(R), PriceFilteredList, PriceAndRatingFilteredList)
        ;
        PriceAndRatingFilteredList = PriceFilteredList
    ).

%% given a price value, return true if restaurant object has the same price
check_price(NumDollarSign, RestaurantDict) :-
    Price = RestaurantDict.get('price'),
    Price == NumDollarSign.

%% given a upper bound rating, return true if the restaurant object has rating within specified range
check_rating(UpperBoundRating, RestaurantDict) :-
    Rating = RestaurantDict.get('rating'),
    Rating =< UpperBoundRating,
    LowerBound is UpperBoundRating - 1.5,
    Rating > LowerBound.

%% get first item from list
get_first([E], E) :- !.
get_first([H|_], H).