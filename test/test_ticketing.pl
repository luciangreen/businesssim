:- begin_tests(ticketing).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

setup_event(EventId) :-
    reset_engine,
    new_simulation(simulation_spec([name('Ticketing Simulation')]), _),
    create_business(business_spec([name('Ticket Biz'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('Door 1'), maximum_occupancy(1)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://ticket')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('Door Test'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://ticket'),
            ticket_price(45.0),
            disclosures([virtual_environment]),
            refund_terms(standard_refunds)
        ]),
        EventId
    ).

test(sell_ticket_valid) :-
    setup_event(EventId),
    sell_ticket(EventId, customer_001, external_terminal, TicketId),
    assertion(sub_atom(TicketId, 0, _, _, ticket_)).

test(door_payment_receipt) :-
    setup_event(EventId),
    record_door_payment(EventId, customer_walk_in, cash, 45.0, ReceiptId),
    assertion(sub_atom(ReceiptId, 0, _, _, receipt_)).

:- end_tests(ticketing).

