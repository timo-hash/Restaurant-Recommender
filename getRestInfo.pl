consult('api.pl').


% get_first_property('response.json', get_rating).
% get_first_property('response.json', get_price).
% get_first_property('response.json', get_name).
get_first_property(FilePath, Property) :-
    json_to_dict(FilePath, Dict),
    get_Businesses_Dict(Dict, ListOfBusiness),
    get_first(ListOfBusiness, Restaurant),
    call(Property, Restaurant).

get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

get_rating(SingleRestaurant) :-
    Rating = SingleRestaurant.get('rating'),
    write('Rating: '), write(Rating), nl.

get_price(SingleRestaurant) :-
    Price = SingleRestaurant.get('price'),
    write('Price: '), write(Price), nl.

get_name(SingleRestaurant) :-
    Name = SingleRestaurant.get('name'),
    write('Name: '), write(Name), nl.

get_first([H|_], H).
get_first([E], E).