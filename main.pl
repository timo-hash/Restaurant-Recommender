:- [api].
:- [nlp].
:- [getRestInfo].

% What is a restaurant in Sydney with deals?
% What is a restaurant in Sydney?

start(Recommendation) :-
    write("Welcome!!\n"),
    write("We are here to give you restaurant recommendations \n\n"),
    askFor(Recommendation).

askFor(Recommendation) :- 
    write("What restaurants would you want to find?\n"), flush_output(current_output),

    read_line_to_string(user_input, St), 
    split_string(St, " -", " ,?.!-", ListOfWords), % ignore punctuation
    ask(ListOfWords, RequestParamsList),

    request_to_query_params(RequestParamsList, QueryParamList),
    make_api_call(QueryParamList, "response.json", ResponseDict),
    check_any_results_returned(ResponseDict, HaveResult),
    (HaveResult == noResultsJSON ->
        write("Sorry, we couldn't find any recommendations for you search, please try again\n"),
        (fail)
        ;
        write("yes\n"),
        true 
    ),
    get_first_restaurant_info(ResponseDict, Recommendation).
    
askFor(Recommendation) :-
    write("No more answers\n"),
    askFor(Recommendation).
