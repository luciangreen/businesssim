:- begin_tests(scenarios).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(infinite_parlour_demo_flow) :-
    reset_engine,
    new_simulation(simulation_spec([name('Scenario Simulation')]), SimulationId),
    create_business(business_spec([name('Infinite Rooms Entertainment'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('12 Small Venue Rd'), maximum_occupancy(12)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://infinite-parlour')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('The Infinite Parlour'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://infinite-parlour'),
            ticket_price(45.0),
            performer(fictional_simulation),
            disclosures([virtual_environment, simulated_fans, fictional_recollection]),
            refund_terms(standard_refunds)
        ]),
        EventId
    ),
    record_door_payment(EventId, customer_walk_in, cash, 45.0, _),
    advance_simulation(SimulationId, datetime(2026, 8, 10, 23, 59, 59), _),
    event_report(EventId, report(event, EventId, Fields)),
    member(real_attendance(metric(actual, 1)), Fields),
    member(apparent_virtual_capacity(metric(simulated, 500)), Fields).

test(seed_reproducibility) :-
    run_simulation(infinite_parlour, 42, ResultA),
    run_simulation(infinite_parlour, 42, ResultB),
    assertion(ResultA == ResultB).

:- end_tests(scenarios).

