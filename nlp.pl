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
    det(L0,L1,C0,C1),
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
    write("debug: QPs = "), write(QPs). % debug

get_request_params(Q,RPs) :-
    question(Q,End,RPs,[]),
    member(End,[[],["?"],["."]]).

det(["the" | L],L,C,C).
det(["a" | L],L,C,C).
det(L,L,C,C).

noun(["restaurant" | L], L,  C, C).
noun(["place" | L], L,  C, C).
noun(["bar" | L], L,  [queryParam("categories", "bars"), queryParam("categories", "cocktailbars"), queryParam("categories", "wine_bars")| C], C).
noun(["cafe" | L], L,  [queryParam("categories", "cafes") | C], C).
noun(["pub" | L], L,  [queryParam("categories", "pubs"), queryParam("categories", "brewpubs") | C], C).
noun(["venue" | L], L,  [queryParam("categories", "venues") | C], C).
noun(["smokehouse" | L], L,  [queryParam("categories", "smokehouse") | C], C).
noun(["steakhouse" | L], L,  [queryParam("categories", "steak") | C], C).
noun(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
noun(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).

adj(["cheap" | L], L, C, C).
adj(["chinese" | L], L,  [queryParam("categories", "chinese") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["cantonese" | L], L,  [queryParam("categories", "cantonese") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "australian") | C], C).
adj(["thai" | L], L,  [queryParam("categories", "thai") | C], C).
adj(["asian", "fusion"| L], L,  [queryParam("categories", "asianfusion") | C], C).
adj(["italian" | L], L,  [queryParam("categories", "italian") | C], C).
adj(["malaysian" | L], L,  [queryParam("categories", "malaysian") | C], C).
adj(["singaporean" | L], L,  [queryParam("categories", "singaporean") | C], C).
adj(["australian" | L], L,  [queryParam("categories", "modern_australian") | C], C).
adj(["european" | L], L,  [queryParam("categories", "modern_european") | C], C).
adj(["mexican" | L], L,  [queryParam("categories", "mexican") | C], C).
adj(["indian" | L], L,  [queryParam("categories", "indpak") | C], C).
adj(["vietnamese" | L], L,  [queryParam("categories", "vietnamese") | C], C).
adj(["lebanese" | L], L,  [queryParam("categories", "lebanese") | C], C).
adj(["spanish" | L], L,  [queryParam("categories", "spanish") | C], C).


adj(["breakfast" | L], L,  [queryParam("categories", "breakfast_brunch") | C], C).
adj(["brunch" | L], L,  [queryParam("categories", "breakfast_brunch") | C], C).
adj(["coffee" | L], L,  [queryParam("categories", "coffee") | C], C).
adj(["burger" | L], L,  [queryParam("categories", "burgers") | C], C).
adj(["seafood" | L], L,  [queryParam("categories", "seafood") | C], C).
adj(["pizza" | L], L,  [queryParam("categories", "pizza") | C], C).
adj(["vegan" | L], L,  [queryParam("categories", "vegan") | C], C).
adj(["vegetarian" | L], L,  [queryParam("categories", "vegetarian") | C], C).

adj(["bistro" | L], L,  [queryParam("categories", "bistro") | C], C).
adj(["tapas" | L], L,  [queryParam("categories", "tapasmallplates") | C], C).