:- module(persistence, [
    save_state/2,
    load_state/2
]).

:- use_module(library(readutil)).

save_state(File, State) :-
    setup_call_cleanup(
        open(File, write, Stream, [encoding(utf8)]),
        write_term(Stream, simulation_dump(version(1), State), [quoted(true), fullstop(true), nl(true)]),
        close(Stream)
    ).

load_state(File, State) :-
    setup_call_cleanup(
        open(File, read, Stream, [encoding(utf8)]),
        read_term(Stream, Term, [syntax_errors(error)]),
        close(Stream)
    ),
    validate_loaded_term(Term, State).

validate_loaded_term(simulation_dump(version(1), State), State) :-
    State = simulation_state(_, _, _, _, _, _, _, _, _, _, _, _, _, _),
    !.
validate_loaded_term(Term, _) :-
    throw(error(validation_error(field(persistence_file), value(Term), reason(invalid_schema)), _)).
