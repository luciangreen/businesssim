:- begin_tests(repl).

:- use_module('../src/command_parser').
:- use_module('../src/repl').
:- use_module('../src/simulation_engine').
:- use_module('../src/business_registry').

test(parse_commands_with_multiword_names) :-
    parse_command("new simulation My Cafe", new_simulation("My Cafe")),
    parse_command("create business Corner Cafe", create_business("Corner Cafe")).

test(parse_empty_name_fails, [fail]) :-
    parse_command("new simulation", _).

test(create_simulation_and_business_from_commands) :-
    reset_engine,
    execute_command(new_simulation("Test Simulation"), created_simulation(SimulationId)),
    active_simulation(SimulationId),
    execute_command(create_business("Corner Cafe"), created_business(BusinessId)),
    find_business(SimulationId, id(BusinessId), business(BusinessId, business_spec(Fields))),
    memberchk(name("Corner Cafe"), Fields).

test(create_business_requires_active_simulation) :-
    reset_engine,
    execute_command(create_business("Corner Cafe"), error(active_simulation_required)).

:- end_tests(repl).
