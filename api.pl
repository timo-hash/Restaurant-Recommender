
% yelp_fusion_api_call('response.json').

:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

%% Makes the API call and retrieves response in JSON format
yelp_fusion_api_call(OutputJSONFileName) :-
    http_open('https://api.yelp.com/v3/businesses/search?location=sydney&term=restaurants&sort_by=best_match&limit=20',
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