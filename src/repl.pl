:- module(repl, [
    start_repl/0
]).

:- use_module(command_parser).

start_repl :-
    writeln('business-suite> type "help" for commands; "quit" to exit.'),
    repl_loop.

repl_loop :-
    write('business-suite> '),
    read_line_to_string(user_input, Line),
    (   Line == end_of_file ; Line == "quit"
    ->  true
    ;   (   parse_command(Line, Command)
        ->  format('Parsed command: ~q~n', [Command])
        ;   writeln('Unrecognized command')
        ),
        repl_loop
    ).

