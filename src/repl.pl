:- module(repl, [
    start_repl/0,
    execute_command/2
]).

:- use_module(command_parser).
:- use_module(simulation_engine).
:- use_module(business_registry).

start_repl :-
    writeln('business-suite> type "help" for commands; "quit" to exit.'),
    repl_loop.

repl_loop :-
    write('business-suite> '),
    read_line_to_string(user_input, Line),
    (   Line == end_of_file
    ->  true
    ;   Line == "quit"
    ->  true
    ;   (   parse_command(Line, Command)
        ->  execute_command(Command, Result),
            print_command_result(Result)
        ;   writeln('Unrecognized command')
        ),
        repl_loop
    ).

execute_command(help, help).
execute_command(new_simulation(Name), created_simulation(SimulationId)) :-
    new_simulation_state(simulation_spec([name(Name)]), SimulationId),
    append_audit_entry(SimulationId, system, new_simulation, SimulationId, ok, _),
    !.
execute_command(create_business(Name), Result) :-
    (   current_simulation(SimulationId)
    ->  create_business_in_state(
            SimulationId,
            business_spec([name(Name), type(small_business), manager(repl_manager)]),
            BusinessId,
            _
        ),
        append_audit_entry(SimulationId, manager, create_business, BusinessId, ok, _),
        Result = created_business(BusinessId)
    ;   Result = error(active_simulation_required)
    ),
    !.

print_command_result(help) :-
    writeln('Commands: help | new simulation <name> | create business <name> | quit').
print_command_result(created_simulation(SimulationId)) :-
    format('Created simulation ~w.~n', [SimulationId]).
print_command_result(created_business(BusinessId)) :-
    format('Created business ~w.~n', [BusinessId]).
print_command_result(error(active_simulation_required)) :-
    writeln('Create a simulation before creating a business.').
