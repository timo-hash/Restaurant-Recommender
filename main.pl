:- consult('api.pl').
:- consult('nlp.pl').
:- consult('getRestInfo.pl').

% What is a restaurant in Sydney with deals?

askFor(Suggestion) :- 
    write("Welcome!!\n"),
    write("We are here to give you restaurant suggestions \n\n"),
    write("What restaurants would you want to find?\n"), flush_output(current_output),

    read_line_to_string(user_input, St), 
    split_string(St, " -", " ,?.!-", ListOfWords), % ignore punctuation
    ask(ListOfWords, RequestParams),
    
askFor(Suggestion) :-
    write("No more answers\n"),
    start.
