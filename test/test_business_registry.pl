:- begin_tests(business_registry).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(create_business_is_registered) :-
    reset_engine,
    new_simulation(simulation_spec([name('Test Simulation')]), _),
    create_business(
        business_spec([
            name('Infinite Rooms Entertainment'),
            type(virtual_entertainment),
            manager(manager_001)
        ]),
        BusinessId
    ),
    atom(BusinessId).

:- end_tests(business_registry).

