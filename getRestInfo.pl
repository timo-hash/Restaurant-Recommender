consult('api.pl').



% get_first_rating('response.json').
get_first_rating(FilePath) :-
    json_to_dict(FilePath, Dict),
    get_Businesses_Dict(Dict, ListOfBusiness),
    get_first(ListOfBusiness, Restaurant),
    get_rating(Restaurant).
    
get_Businesses_Dict(ResponseDict, BusinessesList) :-
    BusinessesList = ResponseDict.get('businesses').

get_rating(SingleRestaurant) :-
    Rating = SingleRestaurant.get('rating'),
    write('Rating: '), write(Rating), nl.

get_first([H|_], H).
get_first([E], E).