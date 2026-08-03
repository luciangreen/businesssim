:- module(reporting, [
    event_report_from_state/3,
    business_report_from_state/4,
    metric_status/1
]).

:- use_module(library(lists)).

metric_status(actual).
metric_status(simulated).
metric_status(forecast).
metric_status(estimated).
metric_status(user_supplied).

event_report_from_state(State, EventId, report(event, EventId, Fields)) :-
    state_events(State, Events),
    member(event(EventId, BusinessId, concert_spec(EventFields), event_state(Status, ActualAttendance, RemoteAttendance, SimulatedCrowd, Revenue, Refunds)), Events),
    find_event_field(EventFields, title, Title, 'Untitled Event'),
    find_event_field(EventFields, physical_location, PhysicalLocation, unknown),
    find_event_field(EventFields, virtual_address, VirtualAddress, unknown),
    find_event_field(EventFields, physical_capacity, PhysicalCapacity, 0),
    find_event_field(EventFields, apparent_capacity, ApparentCapacity, 0),
    Profit is Revenue - Refunds,
    Fields = [
        event_title(metric(actual, Title)),
        business(metric(actual, BusinessId)),
        status(metric(actual, Status)),
        physical_location(metric(actual, PhysicalLocation)),
        virtual_address(metric(actual, VirtualAddress)),
        physical_capacity(metric(actual, PhysicalCapacity)),
        apparent_virtual_capacity(metric(simulated, ApparentCapacity)),
        real_attendance(metric(actual, ActualAttendance)),
        remote_attendance(metric(actual, RemoteAttendance)),
        simulated_crowd_count(metric(simulated, SimulatedCrowd)),
        total_rendered_audience_presences(metric(simulated, TotalRendered)),
        revenue(metric(actual, Revenue)),
        refunds(metric(actual, Refunds)),
        profit(metric(estimated, Profit))
    ],
    TotalRendered is ActualAttendance + RemoteAttendance + SimulatedCrowd.

business_report_from_state(State, BusinessId, Period, report(business, BusinessId, Period, Fields)) :-
    state_events(State, Events),
    findall(Revenue, (
        member(event(_, BusinessId, _, event_state(_, _, _, _, Revenue, _)), Events)
    ), Revenues),
    findall(Refund, (
        member(event(_, BusinessId, _, event_state(_, _, _, _, _, Refund)), Events)
    ), Refunds),
    sum_list(Revenues, RevenueTotal),
    sum_list(Refunds, RefundTotal),
    Profit is RevenueTotal - RefundTotal,
    Fields = [
        cash_balance(metric(estimated, Profit)),
        revenue(metric(actual, RevenueTotal)),
        expenses(metric(actual, 0)),
        profit(metric(estimated, Profit)),
        outstanding_refunds(metric(actual, RefundTotal)),
        genuine_buzz_score(metric(actual, 0)),
        forecast_buzz_score(metric(forecast, 50))
    ].

state_events(simulation_state(_, _, _, _, _, _, _, events(Events), _, _, _, _, _, _), Events).

find_event_field(Fields, Key, Value, Default) :-
    (   member(Term, Fields),
        Term =.. [Key, Candidate]
    ->  Value = Candidate
    ;   Value = Default
    ).
