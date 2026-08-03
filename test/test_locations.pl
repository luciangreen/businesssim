:- begin_tests(locations).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(create_physical_location_with_capacity) :-
    reset_engine,
    new_simulation(simulation_spec([name('Location Simulation')]), _),
    create_physical_location(
        location_spec([address('123 Demo St'), maximum_occupancy(12)]),
        LocationId
    ),
    assertion(sub_atom(LocationId, 0, _, _, location_)).

:- end_tests(locations).

