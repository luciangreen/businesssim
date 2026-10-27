:- module(command_parser, [
    parse_command/2
]).

parse_command(Text, Command) :-
    split_string(Text, " ", "", Parts),
    phrase(command(Command), Parts),
    !.

command(new_simulation(Name)) --> ["new", "simulation"], rest_text(Name).
command(create_business(Name)) --> ["create", "business"], rest_text(Name).
command(help) --> ["help"].

rest_text(Text) -->
    [First | Tokens],
    {
        atomic_list_concat([First | Tokens], ' ', Atom),
        atom_string(Atom, Text)
    }.
