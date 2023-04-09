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

% get_first_property('response.json', get_rating).
% get_first_property('response.json', get_price).
% get_first_property('response.json', get_name).
get_first_property(Dict, Property, ReturnedResult) :-
    get_Businesses_Dict(Dict, ListOfBusiness),
    get_first(ListOfBusiness, Restaurant),
    call(Property, Restaurant, ReturnedResult).

get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

get_rating(SingleRestaurant) :-
    Rating = SingleRestaurant.get('rating'),
    write('Rating: '), write(Rating), nl.

get_price(SingleRestaurant) :-
    Price = SingleRestaurant.get('price'),
    write('Price: '), write(Price), nl.

get_name(SingleRestaurant, Name) :-
    Name = SingleRestaurant.get('name').

get_first([H|_], H).
get_first([E], E).

% my_map([H|_], H)