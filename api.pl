
% yelp_fusion_api_call('response.json').

:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- [apiKey].

%% constants
baseURL('https://api.yelp.com/v3/businesses/search?').
defaultApiSetting('term=restaurants&sort_by=best_match&limit=20&').

make_api_call(QueryParamList, OutputJSONFileName) :-
    create_api_URL(QueryParamList, URL),
    yelp_fusion_api_call(URL, OutputJSONFileName).

create_api_URL(QueryParamList, URL) :-
    baseURL(Base),
    defaultApiSetting(Setting),
    atomic_concat(Base,Setting,R),

    create_query_param_URL(QueryParamList, QueryParamTailURL),
    atomic_concat(R,QueryParamTailURL,URL).

%% Makes the API call and retrieves response in JSON format
yelp_fusion_api_call(API_URL, OutputJSONFileName) :-
    write(KEY), write("\n"),
    write(API_URL),
    yelpFusionApiKey(KEY),
    http_open(API_URL,
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
    atomic_list_concat([K,'=',V,&], S). % builds a single parameter
query_param_URL_helper([queryParam(K,V)|T],R) :-
    atomic_list_concat([K,'=',V,&], S),
    query_param_URL_helper(T,R1),
    string_concat(S,R1,R).

remove_last_char(Str, NewStr) :-
    string_length(Str, Len),
    Len > 0,
    SubLen is Len - 1,
    substring(Str, 1, SubLen, NewStr).
