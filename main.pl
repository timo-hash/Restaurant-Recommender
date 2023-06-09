:- [api].
:- [nlp].
:- [getRestInfo].

%% start here, returns recommendations
iCannotDecide(Recommendation) :-
    write("Welcome!!\n"),
    write("We are here to give you restaurant recommendations (Type 'quit' to exit)\n\n"),
    askFor(Recommendation).

askFor(Recommendation) :- 
    write("What are you looking for?\n"), flush_output(current_output),

    read_line_to_string(user_input, St), 
    split_string(St, " -", " ,?.!-", ListOfWords), % ignore punctuation

    (memberchk("quit", ListOfWords) ->
        write("Goodbye!\n"),
        !,
        fail
        ;
        true
    ),


    get_request_params(ListOfWords, RequestParamsList),
    % write("debug: RequestParamsList = "), write(RequestParamsList), write("\n"),

    
    request_to_query_params(RequestParamsList, QueryParamList),
    make_api_call(QueryParamList, "response.json", ResponseDict),
    check_any_results_returned(ResponseDict, HaveResult),
    (HaveResult == noResultsJSON ->
        write("Sorry, we couldn't find any recommendations for you search, please try again\n"),
        (fail)
        ;
        true 
    ),
    get_num_of_restaurant(ResponseDict, RequestParamsList, Recommendation).
    
askFor(Recommendation) :-
    write("No more answers. \n\n"),
    write("Ask me again! (Type 'quit' to exit)\n"),
    askFor(Recommendation).
