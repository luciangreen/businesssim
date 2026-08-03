:- module(business_suite, [
    new_simulation/2,
    load_simulation/2,
    save_simulation/2,
    create_business/2,
    create_customer/2,
    generate_customers/2,
    create_office/3,
    create_physical_location/2,
    create_virtual_environment/2,
    schedule_concert/3,
    sell_ticket/4,
    record_door_payment/5,
    advance_simulation/3,
    run_simulation/3,
    compliance_check/2,
    business_report/3,
    event_report/2,
    start_repl/0,
    run_demo/0
]).

:- use_module(library(error)).
:- use_module(simulation_engine).
:- use_module(simulation_clock).
:- use_module(business_registry).
:- use_module(customer_model).
:- use_module(customer_generator).
:- use_module(office_model).
:- use_module(location_model).
:- use_module(virtual_environment).
:- use_module(event_model).
:- use_module(compliance, [load_policy_profile/1]).
:- use_module(payment_model).
:- use_module(accounting).
:- use_module(persistence).
:- use_module(reporting).
:- use_module(repl, []).

new_simulation(Spec, SimulationId) :-
    new_simulation_state(Spec, SimulationId),
    append_audit_entry(SimulationId, system, new_simulation, SimulationId, ok, _).

save_simulation(SimulationId, File) :-
    get_simulation_state(SimulationId, State),
    save_state(File, State),
    append_audit_entry(SimulationId, system, save_simulation, file(File), ok, _).

load_simulation(File, SimulationId) :-
    load_state(File, State),
    next_identifier(simulation, SimulationId),
    put_simulation_state(SimulationId, State),
    set_active_simulation(SimulationId),
    append_audit_entry(SimulationId, system, load_simulation, file(File), ok, _).

create_business(Spec, BusinessId) :-
    active_simulation(SimulationId),
    create_business_in_state(SimulationId, Spec, BusinessId, _),
    append_audit_entry(SimulationId, manager, create_business, BusinessId, ok, _).

create_customer(Spec, CustomerId) :-
    active_simulation(SimulationId),
    valid_customer_spec(Spec),
    get_simulation_state(SimulationId, State0),
    next_identifier(customer, CustomerId),
    create_customer_term(CustomerId, Spec, Customer),
    state_component(customers, State0, Customers0),
    append(Customers0, [Customer], Customers),
    set_state_component(customers, State0, Customers, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, create_customer, CustomerId, ok, _).

generate_customers(Profile, CustomerIds) :-
    active_simulation(SimulationId),
    generate_customers_from_profile(Profile, seed(0), GeneratedCustomers),
    get_simulation_state(SimulationId, State0),
    state_component(customers, State0, Customers0),
    add_generated_customers(GeneratedCustomers, SimulationId, Customers0, Customers, CustomerIds),
    set_state_component(customers, State0, Customers, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, generate_customers, generated, ok, _).

add_generated_customers([], _, Customers, Customers, []).
add_generated_customers([generated_customer(_, _, Fields) | Rest], SimulationId, Customers0, Customers, [CustomerId | Ids]) :-
    next_identifier(customer, CustomerId),
    Customer = customer(CustomerId, customer_profile(Fields), simulated(true)),
    append(Customers0, [Customer], Customers1),
    add_generated_customers(Rest, SimulationId, Customers1, Customers, Ids).

create_office(BusinessId, Spec, OfficeId) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State0),
    next_identifier(office, OfficeId),
    create_office_term(OfficeId, BusinessId, Spec, Office),
    state_component(offices, State0, Offices0),
    append(Offices0, [Office], Offices),
    set_state_component(offices, State0, Offices, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, create_office, OfficeId, ok, _).

create_physical_location(Spec, LocationId) :-
    active_simulation(SimulationId),
    valid_location_spec(Spec),
    get_simulation_state(SimulationId, State0),
    next_identifier(location, LocationId),
    Location = physical_location(LocationId, Spec),
    state_component(locations, State0, Locations0),
    append(Locations0, [Location], Locations),
    set_state_component(locations, State0, Locations, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, create_physical_location, LocationId, ok, _).

create_virtual_environment(Spec, EnvironmentId) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State0),
    next_identifier(environment, EnvironmentId),
    create_environment_term(EnvironmentId, Spec, Environment),
    state_component(environments, State0, Envs0),
    append(Envs0, [Environment], Envs),
    set_state_component(environments, State0, Envs, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, create_virtual_environment, EnvironmentId, ok, _).

schedule_concert(BusinessId, Spec, EventId) :-
    active_simulation(SimulationId),
    valid_concert_spec(Spec),
    get_simulation_state(SimulationId, State0),
    next_identifier(event, EventId),
    enrich_concert_spec(Spec, State0, RichSpec),
    create_event_term(EventId, BusinessId, RichSpec, Event),
    state_component(events, State0, Events0),
    append(Events0, [Event], Events),
    set_state_component(events, State0, Events, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, schedule_concert, EventId, ok, _).

enrich_concert_spec(concert_spec(Fields0), State, concert_spec(Fields)) :-
    physical_capacity_from_state(Fields0, State, PhysicalCapacity),
    apparent_capacity_from_state(Fields0, State, ApparentCapacity),
    append(Fields0, [physical_capacity(PhysicalCapacity), apparent_capacity(ApparentCapacity)], Fields).

physical_capacity_from_state(Fields, State, Capacity) :-
    (   memberchk(physical_location(LocationId), Fields),
        state_component(locations, State, Locations),
        member(physical_location(LocationId, location_spec(LocationFields)), Locations),
        physical_capacity_from_location(location_spec(LocationFields), Capacity)
    ->  true
    ;   Capacity = 0
    ).

apparent_capacity_from_state(Fields, State, Capacity) :-
    (   memberchk(environment(EnvironmentId), Fields),
        state_component(environments, State, Envs),
        member(environment(EnvironmentId, environment_spec(EnvFields)), Envs),
        virtual_apparent_capacity(environment_spec(EnvFields), Capacity)
    ->  true
    ;   Capacity = 0
    ).

sell_ticket(EventId, CustomerId, PaymentMethod, TicketId) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State0),
    state_component(events, State0, Events0),
    select(event(EventId, BusinessId, Spec, EventState0), Events0, OtherEvents),
    event_ticket_price(Spec, Price),
    must_be(number, Price),
    ensure_capacity_allows_sale(Spec, EventState0),
    next_identifier(booking, BookingId),
    next_identifier(ticket, TicketId),
    Ticket = ticket(TicketId, BookingId, EventId, active, admission(not_scanned)),
    Booking = booking(BookingId, EventId, CustomerId, Price, confirmed, Ticket),
    state_component(bookings, State0, Bookings0),
    append(Bookings0, [Booking], Bookings),
    update_event_revenue(EventState0, Price, EventState),
    append(OtherEvents, [event(EventId, BusinessId, Spec, EventState)], Events),
    build_payment(SimulationId, CustomerId, BusinessId, Price, ticket_sale(EventId), PaymentMethod, Payment),
    state_component(payments, State0, Payments0),
    append(Payments0, [Payment], Payments),
    set_state_component(bookings, State0, Bookings, S1),
    set_state_component(events, S1, Events, S2),
    set_state_component(payments, S2, Payments, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, sell_ticket, TicketId, ok, _).

record_door_payment(EventId, CustomerId, Method, Amount, ReceiptId) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State0),
    state_component(events, State0, Events0),
    select(event(EventId, BusinessId, Spec, EventState0), Events0, OtherEvents),
    must_be(number, Amount),
    Amount >= 0,
    next_identifier(receipt, ReceiptId),
    build_payment(SimulationId, CustomerId, BusinessId, Amount, door_payment(EventId), Method, Payment),
    state_component(payments, State0, Payments0),
    append(Payments0, [Payment, receipt(ReceiptId, EventId, CustomerId, Method, Amount)], Payments),
    increment_actual_attendance(EventState0, EventState1),
    update_event_revenue(EventState1, Amount, EventState),
    append(OtherEvents, [event(EventId, BusinessId, Spec, EventState)], Events),
    set_state_component(payments, State0, Payments, S1),
    set_state_component(events, S1, Events, State),
    put_simulation_state(SimulationId, State),
    append_audit_entry(SimulationId, manager, record_door_payment, ReceiptId, ok, _).

advance_simulation(SimulationId, ToTimestamp, Events) :-
    get_simulation_state(SimulationId, State0),
    state_component(clock, State0, Clock0),
    advance_clock(Clock0, ToTimestamp, Clock, Advancement),
    set_state_component(clock, State0, Clock, State),
    put_simulation_state(SimulationId, State),
    Events = [Advancement],
    append_audit_entry(SimulationId, system, advance_simulation, ToTimestamp, ok, _).

run_simulation(ScenarioId, Seed, simulation_result(ScenarioId, Seed, Customers, Decisions)) :-
    integer(Seed),
    findall(
        decision(CustomerIndex, EventIndex, purchase_ticket, [seed(Seed)]),
        (between(1, 5, CustomerIndex), EventIndex is ((Seed + CustomerIndex) mod 3) + 1),
        Decisions
    ),
    findall(
        simulated_customer(CustomerIndex, Seed),
        between(1, 5, CustomerIndex),
        Customers
    ).

compliance_check(EntityOrEvent, Findings) :-
    compliance:compliance_check(EntityOrEvent, Findings).

business_report(BusinessId, Period, Report) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State),
    business_report_from_state(State, BusinessId, Period, Report).

event_report(EventId, Report) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State),
    event_report_from_state(State, EventId, Report).

event_ticket_price(concert_spec(Fields), Price) :-
    memberchk(ticket_price(Price), Fields).

ensure_capacity_allows_sale(concert_spec(Fields), event_state(_, ActualAttendance, _, _, _, _)) :-
    (   memberchk(physical_capacity(Capacity), Fields),
        Capacity > 0,
        ActualAttendance >= Capacity
    ->  throw(error(capacity_exceeded(actual_attendance(ActualAttendance), physical_capacity(Capacity)), _))
    ;   true
    ).

update_event_revenue(event_state(Status, A, R, S, Revenue0, Refunds), Amount, event_state(Status, A, R, S, Revenue, Refunds)) :-
    Revenue is Revenue0 + Amount.

increment_actual_attendance(event_state(Status, A0, R, S, Revenue, Refunds), event_state(Status, A, R, S, Revenue, Refunds)) :-
    A is A0 + 1.

build_payment(SimulationId, CustomerId, BusinessId, Amount, Purpose, Method, payment(PaymentTerm, payment_method(Method))) :-
    next_identifier(payment, PaymentId),
    format(atom(ExternalReference), '~w-~w', [SimulationId, PaymentId]),
    payment_request_term(PaymentId, CustomerId, BusinessId, Amount, 'AUD', Purpose, ExternalReference, PaymentTerm),
    append_ledger_for_payment(SimulationId, PaymentId, BusinessId, Amount, Purpose).

append_ledger_for_payment(SimulationId, PaymentId, BusinessId, Amount, Purpose) :-
    get_simulation_state(SimulationId, State0),
    state_component(ledger, State0, Ledger0),
    next_identifier(ledger, EntryId),
    ledger_entry_term(EntryId, BusinessId, timestamp(simulation), cash, revenue, Amount, Purpose, source(PaymentId), Entry),
    append(Ledger0, [Entry], Ledger),
    set_state_component(ledger, State0, Ledger, State),
    put_simulation_state(SimulationId, State).

start_repl :-
    repl:start_repl.

run_demo :-
    reset_engine,
    new_simulation(
        simulation_spec([
            name('Business Simulation Demonstration'),
            currency('AUD'),
            timezone('Australia/Melbourne'),
            time_ratio(time_ratio(real_days(1), simulation_workdays(1)))
        ]),
        SimulationId
    ),
    create_business(
        business_spec([
            name('Infinite Rooms Entertainment'),
            type(virtual_entertainment),
            manager(manager_001)
        ]),
        BusinessId
    ),
    create_physical_location(
        location_spec([
            address('123 Demo Street'),
            maximum_occupancy(12)
        ]),
        PhysicalLocation
    ),
    create_virtual_environment(
        environment_spec([
            apparent_capacity(500),
            uri('virtual://infinite-parlour')
        ]),
        Environment
    ),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('The Infinite Parlour'),
            physical_location(PhysicalLocation),
            environment(Environment),
            virtual_address('virtual://infinite-parlour'),
            ticket_price(45.0),
            performer(fictional_simulation),
            disclosures([virtual_environment, simulated_fans, fictional_recollection]),
            refund_terms(standard_refund_policy)
        ]),
        EventId
    ),
    load_policy_profile(australia_general_entertainment),
    compliance_check(EventId, Findings),
    (member(finding(severity(blocking), _, _, _, _), Findings) -> throw(error(blocking_findings(Findings), _)) ; true),
    record_door_payment(EventId, customer_walk_in, cash, 45.0, _),
    advance_simulation(SimulationId, datetime(2026, 8, 10, 23, 59, 59), _),
    event_report(EventId, Report),
    portray_clause(Report).
