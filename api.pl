
% yelp_fusion_api_call('response.json').

:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

baseURL('https://api.yelp.com/v3/businesses/search?').
    


%% Makes the API call and retrieves response in JSON format
yelp_fusion_api_call(OutputJSONFileName) :-
    atomic_concat('https://api.yelp.com/v3/businesses/search?', 'location=sydney&term=restaurants&sort_by=best_match&limit=20', URL),
    http_open(URL,
              In,
              [authorization(bearer(KEY)),
            request_header('accept': 'application/json')]),
    json_read_dict(In, Dict),
    close(In),
    % Write JSON response to file
    dict_to_json(Dict, OutputJSONFileName).

%% writes dictionary to JSON file, file is saved locally
dict_to_json(Dict, JSONFileName) :-
    atom_string(JSONFileAtom, JSONFileName),
    open(JSONFileAtom, write, Out),
    json_write_dict(Out, Dict),
    close(Out).

%% Converts JSON to dictionary
json_to_dict(FilePath, Dict) :-
    open(FilePath, read, In),
    json_read_dict(In, Dict),
    close(In).

request_to_query_params(Requests, Queries) :-
    findall(queryParam(K,V), member(queryParam(K,V), Requests), Queries).

% request_to_query_params([queryParam("hello","no"), queryParam("yt","nasdfo"), queryParam("asdf","dgh"), qq("hello","no")],Q).
% [queryParam("hello","no"), queryParam("yt","nasdfo"), queryParam("asdf","dgh")]

create_query_param_URL(QueryParamList, QueryParamURLSub) :-
    query_param_URL_helper(QueryParamList, QueryParamURL),
    remove_last_char(QueryParamURL, QueryParamURLSub).

query_param_URL_helper([queryParam(K,V)], S) :-
    build_single_param(queryParam(K,V), S).
query_param_URL_helper([queryParam(K,V)|T],R) :-
    build_single_param(queryParam(K,V), S),
    query_param_URL_helper(T,R1),
    atomic_list_concat([S,R1], R).
  
build_single_param(queryParam(K,V), StringParam) :-
  atomic_list_concat([K,'='], S1),
  atomic_list_concat([S1,V], S2),
  atomic_list_concat([S2,'&'], StringParam).

remove_last_char(Str, NewStr) :-
    string_length(Str, Len),
    Len > 0,
    SubLen is Len - 1,
    substring(Str, 1, SubLen, NewStr).
