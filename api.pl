
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).
:- [apiKey].

%% constants
baseURL('https://api.yelp.com/v3/businesses/search?').
defaultApiSetting('term=restaurants&sort_by=best_match&').

max_offset(950).
max_limit(50).

%% loop through API calls from 0 to max_offset and merge responses into one dictionary
make_api_call(QueryParamList, OutputJSONFileName, ResponseDict) :-
    max_offset(OFFSET),
    max_limit(LIMIT),
    create_list(0, OFFSET, LIMIT, OffsetList),
    maplist(create_api_URL(QueryParamList), OffsetList, UrlList),
    maplist(yelp_fusion_api_call, UrlList, Responses),
    merge_dicts(Responses, ResponseDict),
    dict_to_json(ResponseDict, OutputJSONFileName).

%% creates API url based on user input
create_api_URL(QueryParamList, Offset, URL) :-
    baseURL(Base),
    defaultApiSetting(Setting),
    atomic_concat(Base, Setting, BaseWithSetting),
    max_limit(MaxLimit),
    create_pagination_param_URL(MaxLimit, Offset, PaginationUrl),
    create_query_param_URL(QueryParamList, QueryParamTailURL),
    atomic_concat(BaseWithSetting, PaginationUrl, PaginatedBaseURL),
    atomic_concat(PaginatedBaseURL, QueryParamTailURL, URL).

%% generate query params for limit and offset
create_pagination_param_URL(Limit, Offset, URL) :-
    atomic_concat('limit=', Limit, LimitParamT),
    atomic_concat(LimitParamT, '&', LimitParam),
    atomic_concat('offset=', Offset, OffsetParamT),
    atomic_concat(OffsetParamT, '&', OffsetParam),
    atomic_concat(LimitParam, OffsetParam, URL).

%% makes the API call and retrieves response in JSON format
yelp_fusion_api_call(API_URL, ResponseDict) :-
    yelpFusionApiKey(KEY),
    % write("debug: API_URL = "), write(API_URL), write("\n"),
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
    close(In).

merge_dicts(Dicts, Merged) :-
    sum_totals(Dicts, 0, Total),
    merge_businesses(Dicts, [], MergedBusiness),
    Merged = _{business:MergedBusiness, total:Total}.

merge_businesses([], MergedBusiness, MergedBusiness).
merge_businesses([Dict|Rest], MergedSoFar, Merged) :-
    get_dict(businesses, Dict, Businesses),
    append(Businesses, MergedSoFar, NewMerged),
    merge_businesses(Rest, NewMerged, Merged).

sum_totals([], Total, Total).
sum_totals([Dict|Rest], TotalSoFar, Total) :-
    get_dict(total, Dict, ThisTotal),
    NewTotalSoFar is TotalSoFar + ThisTotal,
    sum_totals(Rest, NewTotalSoFar, Total).

create_list(Lower, Upper, Step, List) :-
    create_list(Lower, Upper, Step, [], List).

create_list(Current, Upper, Step, Acc, [Current|Acc]) :-
    Current + Step > Upper, !.

create_list(Current, Upper, Step, Acc, List) :-
    NewCurrent is Current + Step,
    create_list(NewCurrent, Upper, Step, [Current|Acc], List).

%% writes dictionary to JSON file, file is saved locally
dict_to_json(Dict, JSONFileName) :-
    atom_string(JSONFileAtom, JSONFileName),
    open(JSONFileAtom, write, Out),
    json_write_dict(Out, Dict, [null('')]),
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
