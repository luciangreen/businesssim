:- begin_tests(virtual_environments).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').
:- use_module('../src/reporting').

test(virtual_capacity_is_separate_from_physical) :-
    reset_engine,
    new_simulation(simulation_spec([name('Virtual Separation')]), _),
    create_business(business_spec([name('VBiz'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('1 Main Rd'), maximum_occupancy(12)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://hall')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('The Infinite Parlour'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://hall'),
            ticket_price(45.0),
            disclosures([virtual_environment]),
            refund_terms(standard_refunds)
        ]),
        EventId
    ),
    event_report(EventId, report(event, EventId, Fields)),
    member(physical_capacity(metric(actual, 12)), Fields),
    member(apparent_virtual_capacity(metric(simulated, 500)), Fields).

:- end_tests(virtual_environments).

