:- begin_tests(accounting).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(ticket_sale_creates_revenue_reportable) :-
    reset_engine,
    new_simulation(simulation_spec([name('Accounting Simulation')]), _),
    create_business(business_spec([name('Acct Biz'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('10 Ledger Lane'), maximum_occupancy(12)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://acct')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('Accounting Night'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://acct'),
            ticket_price(50.0),
            disclosures([virtual_environment]),
            refund_terms(standard_refunds)
        ]),
        EventId
    ),
    sell_ticket(EventId, customer_001, external_terminal, _),
    event_report(EventId, report(event, EventId, Fields)),
    member(revenue(metric(actual, Revenue)), Fields),
    assertion(Revenue =:= 50.0).

:- end_tests(accounting).

