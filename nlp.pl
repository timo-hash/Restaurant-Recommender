% ask(["What", "is", "a", "restaurant", "in", "Sydney"], A).
% ask(["What", "is", "a", "restaurant", "in", "Sydney", "with", "deals"], A).


% question(["Is" | L0],L2,C0,C2) :-
%     noun_phrase(L0,L1,C0,C1),
%     mp(L1,L2,C1,C2).
question(["What","is" | L0],L1,C0,C1) :-
    aphrase(L0,L1,C0,C1).
% question(["What" | L0],L2,C0,C2) :-
%     noun_phrase(L0,L1,C0,C1),
%     mp(L1,L2,C1,C2).
% question(["What" | L0],L1,C0,C1) :-
%     mp(L0,L1,C0,C1).

noun(["restaurant" | L], L,  C, C).
% noun(["bar" | L], L, [bar(Ind) | C], C).

adj(["cheap" | L], L, C, C).

noun_phrase(L0,L5,C0,C5) :-
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
    ap(L1,L2,C1,C2).
oap(L,L,C,C).

connectingPhrase(["with" | L],L,C,C).
connectingPhrase(["that", "has" | L],L,C,C).

% additional properties
ap(["deals" | L], L, [queryParam("attribute", "deals") | C], C).
ap(["outdoor", "seating" | L], L, [queryParam("attribute", "outdoor_seating") | C], C).

adjectives(L0,L2,C0,C2) :-
    adj(L0,L1,C0,C1),
    adjectives(L1,L2,C1,C2).
adjectives(L,L,C,C).

aphrase(L0, L1,C0,C1) :- noun_phrase(L0, L1,C0,C1).
omp(L,L,_,C,C).

det(["the" | L],L,C,C).
det(["a" | L],L,C,C).
det(L,L,C,C).

ask(Q,QPs) :-
    get_request_params(Q,QPs),
    write("debug: QPs = "), write(QPs). % debug

get_request_params(Q,RPs) :-
    question(Q,End,RPs,[]),
    member(End,[[],["?"],["."]]).