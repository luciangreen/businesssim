:- begin_tests(concerts).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(schedule_concert) :-
    reset_engine,
    new_simulation(simulation_spec([name('Concert Simulation')]), _),
    create_business(business_spec([name('Concert Biz'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('123 Stage Ave'), maximum_occupancy(12)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://stage')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('Virtual Night'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://stage'),
            ticket_price(30.0),
            disclosures([virtual_environment, simulated_performer]),
            refund_terms(standard_refunds)
        ]),
        EventId
    ),
    assertion(sub_atom(EventId, 0, _, _, event_)).

:- end_tests(concerts).

