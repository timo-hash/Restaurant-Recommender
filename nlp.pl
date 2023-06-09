question(["Recommend","me" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["recommend","me" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["Enlighten","me", "with" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["enlighten","me", "with" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["Give","me" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["Give","me","recommendations","for" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["give","me" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["What","is" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["what","is" | L0],L1,C0,C1) :-
    description_phrase(L0,L1,C0,C1).
question(["What","are" | L0],L1, [numOfRest(5) | C0],C1) :-
    description_phrase(L0,L1,C0,C1).
question(["what","are" | L0],L1, [numOfRest(5) | C0],C1) :-
    description_phrase(L0,L1,C0,C1).

%% a modified noun phrase
description_phrase(L0,L5,C0,C5) :-
    count(L0,L1,C0,C1),
    adjectives(L1,L2,C1,C2),
    noun(L2,L3,C2,C3),
    locPhrase(L3,L4,C3,C4),
    oap(L4,L5,C4,C5).

% optional attribute phrase
oap(L0,L2,C0,C2) :-
    connectingPhrase(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
oap(L,L,C,C).

% additional properties (a, b, and c | a and b)
aps(L0,L2,C0,C2) :-
    ap(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
aps(L0,L2,C0,C2) :-
    and_conj(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
aps(L,L,C,C).

%% represent 1 or more adjetives
adjectives(L0,L2,C0,C2) :-
    adj(L0,L1,C0,C1),
    adjectives(L1,L2,C1,C2).
adjectives(L,L,C,C).

%% parse user input string to a list of request parameters
get_request_params(Q,RPs) :-
    question(Q,End,RPs,[]),
    % write("debug: QPs = "), write(RPs), write("\n"), % debug
    member(End,[[],["?"],["."]]).

%% Knowledge base

count(["some" | L],L,[numOfRest(5)| C],C).
count(["a", "couple", "of" | L],L,[numOfRest(5)| C],C) :- !.
count(["a", "few" | L],L,[numOfRest(5)| C],C) :- !.
count(["a" | L],L,[numOfRest(1)| C],C).
count(["an" | L],L,[numOfRest(1)| C],C).
count(["1" | L],L,[numOfRest(1)| C],C).
count(["one" | L],L,[numOfRest(1)| C],C).
count(L,L,[numOfRest(5)| C],C).

% location phrase
locPhrase(["in", City | L], L, [queryParam("location", City) | C], C).

%% phrase used to add additional detail to the previous phrase/noun
connectingPhrase(["with" | L],L,C,C).
connectingPhrase(["that", "has" | L],L,C,C).
connectingPhrase(["that", "have" | L],L,C,C).
connectingPhrase(["that", "is" | L],L,C,C).
connectingPhrase(["that", "are" | L],L,C,C).
connectingPhrase(["which", "has" | L],L,C,C).
connectingPhrase(["which", "have" | L],L,C,C).
connectingPhrase(["which", "is" | L],L,C,C).
connectingPhrase(["which", "are" | L],L,C,C).

%% and
and_conj(["and" | L],L,C,C).

%% user/JSON specific filers
ap(["cheap" | L], L, [jsonFilter("price", "$") | C], C).
ap(["reasonably", "priced" | L], L, [jsonFilter("price", "$$") | C], C).
ap(["affordable" | L], L, [jsonFilter("price", "$$") | C], C).
ap(["expensive" | L], L, [jsonFilter("price", "$$$") | C], C).
ap(["very", "expensive" | L], L, [jsonFilter("price", "$$$$") | C], C).
ap(["poorly", "rated" | L], L, [jsonFilter("rating", 2.0) | C], C).
ap(["moderately", "rated" | L], L, [jsonFilter("rating", 3.5) | C], C).
ap(["highly", "rated" | L], L, [jsonFilter("rating", 5.0) | C], C).
%% additional property (free)
ap(["deals" | L], L, [queryParam("attributes", "deals") | C], C).
ap(["hot", "and", "new" | L], L, [queryParam("attributes", "hot_and_new") | C], C).
ap(["reservations" | L], L, [queryParam("attributes", "reservation") | C], C).
ap(["gender", "neutral", "restrooms" | L], L, [queryParam("attributes", "gender_neutral_restrooms") | C], C).
ap(["gender", "neutral", "restroom" | L], L, [queryParam("attributes", "gender_neutral_restrooms") | C], C).
ap(["open", "to", "all " | L], L, [queryParam("attributes", "open_to_all") | C], C).
ap(["wheelchair", "accessible" | L], L, [queryParam("attributes", "wheelchair_accessible") | C], C).
%% additional property (premium)
ap(["outdoor", "seating" | L], L, [queryParam("attributes", "outdoor_seating") | C], C).
ap(["parking" | L], L, [queryParam("attributes", "parking_lot") | C], C).
ap(["parking", "lot" | L], L, [queryParam("attributes", "parking_lot") | C], C).

noun(["restaurant" | L], L,  C, C).
noun(["restaurants" | L], L,  [numOfRest(5)| C], C).
noun(["place" | L], L,  C, C).
noun(["places" | L], L, [numOfRest(5)| C], C).
noun(["shop" | L], L,  C, C).
noun(["shops" | L], L,  [numOfRest(5)| C], C).
noun(["store" | L], L,  C, C).
noun(["stores" | L], L,  [numOfRest(5)| C], C).
noun(["house" | L], L,  C, C).
noun(["cocktail", "bar" | L], L,  [queryParam("categories", "cocktailbars") | C], C).
noun(["cocktail", "bars" | L], L,  [numOfRest(5), queryParam("categories", "cocktailbars") | C], C).
noun(["wine", "bar" | L], L,  [queryParam("categories", "wine_bars") | C], C).
noun(["wine", "bars" | L], L,  [numOfRest(5), queryParam("categories", "wine_bars") | C], C).
noun(["sports", "bar" | L], L,  [queryParam("categories", "sportsbars") | C], C).
noun(["sports", "bars" | L], L,  [numOfRest(5), queryParam("categories", "sportsbars") | C], C).
noun(["whisky", "bar" | L], L,  [queryParam("categories", "whiskeybars") | C], C).
noun(["whisky", "bars" | L], L,  [numOfRest(5), queryParam("categories", "whiskeybars") | C], C).
noun(["pub" | L], L,  [queryParam("categories", "pubs") | C], C).
noun(["pubs" | L], L,  [numOfRest(5), queryParam("categories", "pubs") | C], C).
noun(["brewpub" | L], L,  [queryParam("categories", "brewpubs") | C], C).
noun(["brewpubs" | L], L,  [numOfRest(5), queryParam("categories", "brewpubs") | C], C).
noun(["gastropub" | L], L,  [queryParam("categories", "gastropubs") | C], C).
noun(["gastropubs" | L], L,  [numOfRest(5), queryParam("categories", "gastropubs") | C], C).
noun(["venue" | L], L,  [queryParam("categories", "venues") | C], C).
noun(["venues" | L], L,  [numOfRest(5), queryParam("categories", "venues") | C], C).
noun(["smokehouse" | L], L,  [queryParam("categories", "smokehouse") | C], C).
noun(["steakhouse" | L], L,  [queryParam("categories", "steak") | C], C).
noun(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
noun(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).
noun(["soul", "food" | L], L,  [queryParam("categories", "soulfood") | C], C).
noun(["diners" | L], L,  [queryParam("categories", "diners") | C], C).
noun(["hkcafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["hk", "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["HK", "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["Hong", "Kong", "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["lounge" | L], L,  [queryParam("categories", "lounges") | C], C).
noun(["lounges" | L], L,  [numOfRest(5), queryParam("categories", "lounges") | C], C).
noun(["comfort", "food" | L], L,  [queryParam("categories", "comfortfood") | C], C).
noun(["poutinerie" | L], L,  [queryParam("categories", "poutineries") | C], C).
noun(["poutineries" | L], L,  [numOfRest(5), queryParam("categories", "poutineries") | C], C).


adj(["cheap" | L], L, [jsonFilter("price", "$") | C], C).
adj(["reasonably", "priced" | L], L, [jsonFilter("price", "$$") | C], C).
adj(["affordable" | L], L, [jsonFilter("price", "$$") | C], C).
adj(["expensive" | L], L, [jsonFilter("price", "$$$") | C], C).
adj(["very", "expensive" | L], L, [jsonFilter("price", "$$$$") | C], C).
adj(["poorly", "rated" | L], L, [jsonFilter("rating", 2.0) | C], C).
adj(["moderately", "rated" | L], L, [jsonFilter("rating", 3.5) | C], C).
adj(["highly", "rated" | L], L, [jsonFilter("rating", 5.0) | C], C).

adj(["Chinese" | L], L,  [queryParam("categories", "chinese") | C], C).
adj(["chinese" | L], L,  [queryParam("categories", "chinese") | C], C).
adj(["Japanese" | L], L,  [queryParam("categories", "japanese") | C], C).
adj(["japanese" | L], L,  [queryParam("categories", "japanese") | C], C).
adj(["Australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["Cantonese" | L], L,  [queryParam("categories", "cantonese") | C], C).
adj(["cantonese" | L], L,  [queryParam("categories", "cantonese") | C], C).
adj(["Australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["Thai" | L], L,  [queryParam("categories", "thai") | C], C).
adj(["thai" | L], L,  [queryParam("categories", "thai") | C], C).
adj(["Asian", "fusion"| L], L,  [queryParam("categories", "asianfusion") | C], C).
adj(["asian", "fusion"| L], L,  [queryParam("categories", "asianfusion") | C], C).
adj(["Italian" | L], L,  [queryParam("categories", "italian") | C], C).
adj(["italian" | L], L,  [queryParam("categories", "italian") | C], C).
adj(["Malaysian" | L], L,  [queryParam("categories", "malaysian") | C], C).
adj(["malaysian" | L], L,  [queryParam("categories", "malaysian") | C], C).
adj(["Singaporean" | L], L,  [queryParam("categories", "singaporean") | C], C).
adj(["singaporean" | L], L,  [queryParam("categories", "singaporean") | C], C).
adj(["Australian" | L], L,  [queryParam("categories", "modern_australian") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "modern_australian") | C], C).
adj(["European" | L], L,  [queryParam("categories", "modern_european") | C], C).
adj(["european" | L], L,  [queryParam("categories", "modern_european") | C], C).
adj(["Mexican" | L], L,  [queryParam("categories", "mexican") | C], C).
adj(["mexican" | L], L,  [queryParam("categories", "mexican") | C], C).
adj(["Indian" | L], L,  [queryParam("categories", "indpak") | C], C).
adj(["indian" | L], L,  [queryParam("categories", "indpak") | C], C).
adj(["Vietnamese" | L], L,  [queryParam("categories", "vietnamese") | C], C).
adj(["vietnamese" | L], L,  [queryParam("categories", "vietnamese") | C], C).
adj(["Lebanese" | L], L,  [queryParam("categories", "lebanese") | C], C).
adj(["lebanese" | L], L,  [queryParam("categories", "lebanese") | C], C).
adj(["American" | L], L,  [queryParam("categories", "newamerican") | C], C).
adj(["american" | L], L,  [queryParam("categories", "newamerican") | C], C).
adj(["traditional", "American" | L], L,  [queryParam("categories", "tradamerican") | C], C).
adj(["traditional", "american" | L], L,  [queryParam("categories", "tradamerican") | C], C).
adj(["British" | L], L,  [queryParam("categories", "british") | C], C).
adj(["british" | L], L,  [queryParam("categories", "british") | C], C).
adj(["Canadian" | L], L,  [queryParam("categories", "newcanadian") | C], C).
adj(["canadian" | L], L,  [queryParam("categories", "newcanadian") | C], C).
adj(["Korean" | L], L,  [queryParam("categories", "korean") | C], C).
adj(["korean" | L], L,  [queryParam("categories", "korean") | C], C).
adj(["Cambodian" | L], L,  [queryParam("categories", "cambodian") | C], C).
adj(["cambodian" | L], L,  [queryParam("categories", "cambodian") | C], C).
adj(["Mideastern" | L], L,  [queryParam("categories", "mideastern") | C], C).
adj(["mideastern" | L], L,  [queryParam("categories", "mideastern") | C], C).
adj(["French" | L], L,  [queryParam("categories", "french") | C], C).
adj(["french" | L], L,  [queryParam("categories", "french") | C], C).
adj(["Mediterranean" | L], L,  [queryParam("categories", "mediterranean") | C], C).
adj(["mediterranean" | L], L,  [queryParam("categories", "mediterranean") | C], C).
adj(["Taiwanese" | L], L,  [queryParam("categories", "taiwanese") | C], C).
adj(["taiwanese" | L], L,  [queryParam("categories", "taiwanese") | C], C).
adj(["Cajun" | L], L,  [queryParam("categories", "cajun") | C], C).
adj(["cajun" | L], L,  [queryParam("categories", "cajun") | C], C).
adj(["Creole" | L], L,  [queryParam("categories", "cajun") | C], C).
adj(["creole" | L], L,  [queryParam("categories", "cajun") | C], C).
adj(["Irish" | L], L,  [queryParam("categories", "irish") | C], C).
adj(["irish" | L], L,  [queryParam("categories", "irish") | C], C).


adj(["breakfast" | L], L,  [queryParam("categories", "breakfast_brunch") | C], C).
adj(["brunch" | L], L,  [queryParam("categories", "breakfast_brunch") | C], C).
adj(["coffee" | L], L,  [queryParam("categories", "coffee") | C], C).
adj(["burger" | L], L,  [queryParam("categories", "burgers") | C], C).
adj(["seafood" | L], L,  [queryParam("categories", "seafood") | C], C).
adj(["pizza" | L], L,  [queryParam("categories", "pizza") | C], C).
adj(["salad" | L], L,  [queryParam("categories", "salad") | C], C).
adj(["bubble", "tea" | L], L,  [queryParam("categories", "bubbletea") | C], C).
adj(["dumpling" | L], L,  [queryParam("categories", "dumplings") | C], C).
adj(["dimsum" | L], L,  [queryParam("categories", "dimsum") | C], C).
adj(["bbq" | L], L,  [queryParam("categories", "bbq") | C], C).
adj(["noodles" | L], L,  [queryParam("categories", "noodles") | C], C).
adj(["hotpot" | L], L,  [queryParam("categories", "hotpot") | C], C).
adj(["hotpot" | L], L,  [queryParam("categories", "sandwiches") | C], C).
adj(["hotpot" | L], L,  [queryParam("categories", "hotdogs") | C], C).
% adj([_ | L], L, C, C).

adj(["vegan" | L], L,  [queryParam("categories", "vegan") | C], C).
adj(["vegetarian" | L], L,  [queryParam("categories", "vegetarian") | C], C).
%% noun and adj
adj(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
adj(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).
adj(["soul", "food" | L], L,  [queryParam("categories", "soulfood") | C], C).
