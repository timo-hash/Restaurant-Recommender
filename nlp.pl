% ask(["What", "is", "a", "restaurant", "in", "Sydney"], A).
% ask(["What", "is", "a", "restaurant", "in", "Sydney", "with", "deals"], A).


% question(["Is" | L0],L2,C0,C2) :-
%     description_phrase(L0,L1,C0,C1),
%     mp(L1,L2,C1,C2).
question(["What","is" | L0],L1,C0,C1) :-
    aphrase(L0,L1,C0,C1).
% question(["What" | L0],L2,C0,C2) :-
%     description_phrase(L0,L1,C0,C1),
%     mp(L1,L2,C1,C2).
% question(["What" | L0],L1,C0,C1) :-
%     mp(L0,L1,C0,C1).

description_phrase(L0,L5,C0,C5) :-
    count(L0,L1,C0,C1),
    adjectives(L1,L2,C1,C2),
    noun(L2,L3,C2,C3),
    locPhrase(L3,L4,C3,C4),
    oap(L4,L5,C4,C5).

% location phrase
locPhrase(["in", City | L], L, [queryParam("location", City) | C], C).

% optional attribute phrase
oap(L0,L2,C0,C2) :-
    connectingPhrase(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
oap(L,L,C,C).

connectingPhrase(["with" | L],L,C,C).
connectingPhrase(["that", "has" | L],L,C,C).

% additional properties
aps(L0,L2,C0,C2) :-
    ap(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
aps(L0,L2,C0,C2) :-
    and_conj(L0,L1,C0,C1),
    aps(L1,L2,C1,C2).
aps(L,L,C,C).

% and
and_conj(["and" | L],L,C,C).

% additional property
ap(["deals" | L], L, [queryParam("attributes", "deals") | C], C).
ap(["outdoor", "seating" | L], L, [queryParam("attributes", "outdoor_seating") | C], C).
ap(["parking" | L], L, [queryParam("attributes", "parking_lot") | C], C).
ap(["parking", "lot" | L], L, [queryParam("attributes", "parking_lot") | C], C).

adjectives(L0,L2,C0,C2) :-
    adj(L0,L1,C0,C1),
    adjectives(L1,L2,C1,C2).
adjectives(L,L,C,C).

aphrase(L0, L1,C0,C1) :- description_phrase(L0,L1,C0,C1).
omp(L,L,_,C,C).

ask(Q,QPs) :-
    get_request_params(Q,QPs),
    write("debug: QPs = "), write(QPs), write("\n"). % debug

get_request_params(Q,RPs) :-
    question(Q,End,RPs,[]),
    member(End,[[],["?"],["."]]).

%% from the parsed question, find the number of restaurants requested by the user 
number_of_item_requested(RequestParamsList, X) :-
    (member(numOfRest(1), RequestParamsList) ->
        X is 1
        ;
        X is 20
    ).
    

count(["some" | L],L,[numOfRest(5)| C],C).
count(["a", "couple", "of" | L],L,[numOfRest(5)| C],C) :- !.
count(["a", "few" | L],L,[numOfRest(5)| C],C) :- !.
count(["a" | L],L,[numOfRest(1)| C],C).
count(["an" | L],L,[numOfRest(1)| C],C).
count(["1" | L],L,[numOfRest(1)| C],C).
count(["one" | L],L,[numOfRest(1)| C],C).
count(L,L,[numOfRest(1)| C],C).


noun(["restaurant" | L], L,  C, C).
noun(["restaurants" | L], L,  [numOfRest(5)| C], C).
noun(["place" | L], L,  C, C).
noun(["shop" | L], L,  C, C).
noun(["shops" | L], L,  [numOfRest(5)| C], C).
noun(["store" | L], L,  C, C).
noun(["stores" | L], L,  [numOfRest(5)| C], C).
noun(["house" | L], L,  C, C).
noun(["bar" | L], L,  [queryParam("categories", "bars"), queryParam("categories", "cocktailbars"), queryParam("categories", "wine_bars"), queryParm("categories", "sportsbars") | C], C).
noun(["bars" | L], L,  [numOfRest(5), queryParam("categories", "bars"), queryParam("categories", "cocktailbars"), queryParam("categories", "wine_bars"), queryParm("categories", "sportsbars") | C], C).
noun(["cafe" | L], L,  [queryParam("categories", "cafes") | C], C).
noun(["cafes" | L], L,  [numOfRest(5), queryParam("categories", "cafes") | C], C).
noun(["pub" | L], L,  [queryParam("categories", "pubs"), queryParam("categories", "brewpubs"), queryParam("categories", "gastropubs")| C], C).
noun(["pubs" | L], L,  [numOfRest(5), queryParam("categories", "pubs"), queryParam("categories", "brewpubs"), queryParam("categories", "gastropubs")| C], C).
noun(["venue" | L], L,  [queryParam("categories", "venues") | C], C).
noun(["venues" | L], L,  [numOfRest(5), queryParam("categories", "venues") | C], C).
noun(["smokehouse" | L], L,  [queryParam("categories", "smokehouse") | C], C).
noun(["steakhouse" | L], L,  [queryParam("categories", "steak") | C], C).
noun(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
noun(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).
noun(["soul", "food" | L], L,  [queryParam("categories", "soulfood") | C], C).
noun(["diners" | L], L,  [queryParam("categories", "diners") | C], C).
noun(["hkcafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["hk" "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["HK", "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["Hong" "Kong", "cafe" | L], L,  [queryParam("categories", "hkcafe") | C], C).
noun(["lounge" | L], L,  [queryParam("categories", "lounges") | C], C).
noun(["lounges" | L], L,  [numOfRest(5), queryParam("categories", "lounges") | C], C).
noun(["comfort", "food" | L], L,  [queryParam("categories", "comfortfood") | C], C).
noun(["poutinerie" | L], L,  [queryParam("categories", "poutineries") | C], C).
noun(["poutineries" | L], L,  [numOfRest(5), queryParam("categories", "poutineries") | C], C).


adj(["cheap" | L], L, [jsonFilter("price", "$") | C], C).
adj(["resonably", "priced" | L], L, [jsonFilter("price", "$$") | C], C).
adj(["affordable" | L], L, [jsonFilter("price", "$$") | C], C).
adj(["expensive" | L], L, [jsonFilter("price", "$$$") | C], C).
adj(["very", "expensive" | L], L, [jsonFilter("price", "$$$$") | C], C).
adj(["poorly", "rated" | L], L, [jsonFilter("rating", 2.0) | C], C).
adj(["moderately", "rated" | L], L, [jsonFilter("rating", 3.5) | C], C).
adj(["highly", "rated" | L], L, [jsonFilter("rating", 5.0) | C], C).
adj(["Chinese" | L], L,  [queryParam("categories", "chinese") | C], C).

adj(["Australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["Cantonese" | L], L,  [queryParam("categories", "cantonese") | C], C).
adj(["Australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["Thai" | L], L,  [queryParam("categories", "thai") | C], C).
adj(["Asian", "fusion"| L], L,  [queryParam("categories", "asianfusion") | C], C).
adj(["Italian" | L], L,  [queryParam("categories", "italian") | C], C).
adj(["Malaysian" | L], L,  [queryParam("categories", "malaysian") | C], C).
adj(["Singaporean" | L], L,  [queryParam("categories", "singaporean") | C], C).
adj(["Australian" | L], L,  [queryParam("categories", "modern_australian") | C], C).
adj(["European" | L], L,  [queryParam("categories", "modern_european") | C], C).
adj(["Mexican" | L], L,  [queryParam("categories", "mexican") | C], C).
adj(["Indian" | L], L,  [queryParam("categories", "indpak") | C], C).
adj(["Vietnamese" | L], L,  [queryParam("categories", "vietnamese") | C], C).
adj(["Lebanese" | L], L,  [queryParam("categories", "lebanese") | C], C).
adj(["American" | L], L,  [queryParam("categories", "newamerican") | C], C).
adj(["traditional", "American" | L], L,  [queryParam("categories", "tradamerican") | C], C).
adj(["British" | L], L,  [queryParam("categories", "british") | C], C).
adj(["Canadian" | L], L,  [queryParam("categories", "newcanadian") | C], C).
adj(["Korean" | L], L,  [queryParam("categories", "korean") | C], C).
adj(["Cambodian" | L], L,  [queryParam("categories", "cambodian") | C], C).
adj(["Mideastern" | L], L,  [queryParam("categories", "mideastern") | C], C).
adj(["French" | L], L,  [queryParam("categories", "french") | C], C).
adj(["Mediterranean" | L], L,  [queryParam("categories", "mediterranean") | C], C).
adj(["Taiwanese" | L], L,  [queryParam("categories", "taiwanese") | C], C).
adj(["Cajun" | L], L,  [queryParam("categories", "cajun") | C], C).
adj(["Creole" | L], L,  [queryParam("categories", "cajun") | C], C).


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


adj(["vegan" | L], L,  [queryParam("categories", "vegan") | C], C).
adj(["vegetarian" | L], L,  [queryParam("categories", "vegetarian") | C], C).
%% noun and adj
adj(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
adj(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).
adj(["soul", "food" | L], L,  [queryParam("categories", "soulfood") | C], C).
