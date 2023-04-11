
% yelp_fusion_api_call('response.json').

:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- [apiKey].

%% constants
baseURL('https://api.yelp.com/v3/businesses/search?').
% max limit = 50, max offset = 1000. Adjust offset to get different results
defaultApiSetting('term=restaurants&sort_by=best_match&limit=50&offset=200&').

%% creates API url, makes API call and retrieves response
make_api_call(QueryParamList, OutputJSONFileName, ResponseDict) :-
    create_api_URL(QueryParamList, URL),
    yelp_fusion_api_call(URL, OutputJSONFileName, ResponseDict).

%% creates API url based on user input
create_api_URL(QueryParamList, URL) :-
    baseURL(Base),
    defaultApiSetting(Setting),
    atomic_concat(Base,Setting,R),
    create_query_param_URL(QueryParamList, QueryParamTailURL),
    atomic_concat(R,QueryParamTailURL,URL).

%% Makes the API call and retrieves response in JSON format
yelp_fusion_api_call(API_URL, OutputJSONFileName, ResponseDict) :-
    yelpFusionApiKey(KEY),
    % write("debug: API_URL = "), write(API_URL), write("\n"), %debug
    catch(
        http_open(API_URL,In,
              [authorization(bearer(KEY)), request_header('accept': 'application/json')]),
        _, % Exception
        (
            write("Sorry we didn't get that, make sure the sentence is correct.\n"),
            % format('Exception caught: ~w~n', [Exception]),  %debug
            fail
        )
    ),
    json_read_dict(In, ResponseDict),
    close(In),
    % Write JSON response to file
    dict_to_json(ResponseDict, OutputJSONFileName).

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

%% Given a list of all the request parsed, return a list of only query parameters
request_to_query_params(Requests, Queries) :-
    findall(queryParam(K,V), member(queryParam(K,V), Requests), Queries).

%% Given a list of all query parameters, return a list with only attributes parameter
find_attributes_query_param(QP, AQP) :-
    findall(queryParam("attributes",V), member(queryParam("attributes",V), QP), AQP).

%% Given a list of all query parameters, return a list with only categories parameter
find_categories_query_param(QP, CQP) :-
    findall(queryParam("categories",V), member(queryParam("categories",V), QP), CQP).

%% Given a list of all query parameters, return a list with only location parameter
find_location_query_param(QP, LQP) :-
    findall(queryParam("location",V), member(queryParam("location",V), QP), LQP).


%% concatenates all query parameters into a string from user input
create_query_param_URL(QueryParamList, QueryParamURLEndingRemoved) :-
    find_location_query_param(QueryParamList, LocationList),
    build_query_param_URL(LocationList, LocationParamURL),
    find_categories_query_param(QueryParamList, CategoriesList),
    build_query_param_URL(CategoriesList, CategoriesParamURL),
    find_attributes_query_param(QueryParamList, AttributesList),
    build_query_param_URL(AttributesList, AttributesParamURL),
    atomic_list_concat([LocationParamURL, CategoriesParamURL, AttributesParamURL], QueryParamURL),
    remove_last_char(QueryParamURL, QueryParamURLEndingRemoved).

%% build a singple query parameter string from user input
build_query_param_URL([], "") :- !.
build_query_param_URL([queryParam(K,V)], S) :-
    atomic_list_concat([K,'=',V,'&'], S), % builds a single parameter
    !.
build_query_param_URL([queryParam(K,V)|T],R) :-
    atomic_list_concat([K,'=',V,','], S),
    concat_other_params(T,R1),
    atomic_list_concat([S,R1,'&'],R).

%% concatenates query parameter values with the same key to string
concat_other_params([queryParam(_,V)], V) :- !.
concat_other_params([queryParam(_,V) | Tail], CommaSepString) :-
    atomic_list_concat([V,',',OtherCommaSepString], CommaSepString),
    concat_other_params(Tail, OtherCommaSepString).

%% remove last character from string
remove_last_char(Str, NewStr) :-
    string_length(Str, Len),
    Len > 0,
    SubLen is Len - 1,
    substring(Str, 1, SubLen, NewStr).
