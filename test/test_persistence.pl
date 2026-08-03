:- begin_tests(persistence).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(save_and_load_round_trip) :-
    reset_engine,
    new_simulation(simulation_spec([name('Persistence Simulation')]), SimulationId),
    create_business(business_spec([name('Persist Biz'), type(virtual_entertainment), manager(manager_001)]), _),
    File = 'test/tmp_simulation_state.pl',
    save_simulation(SimulationId, File),
    load_simulation(File, LoadedSimulationId),
    LoadedSimulationId \= SimulationId.

:- end_tests(persistence).

