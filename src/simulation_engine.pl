:- module(simulation_engine, [
    reset_engine/0,
    new_simulation_state/2,
    get_simulation_state/2,
    put_simulation_state/2,
    update_simulation_state/3,
    set_active_simulation/1,
    active_simulation/1,
    current_simulation/1,
    next_identifier/2,
    append_audit_entry/6,
    state_component/3,
    set_state_component/4,
    default_time_ratio/1
]).

:- dynamic simulation_store/2.
:- dynamic active_simulation_id/1.
:- dynamic id_counter/2.

default_time_ratio(time_ratio(real_days(1), simulation_workdays(1))).

reset_engine :-
    retractall(simulation_store(_, _)),
    retractall(active_simulation_id(_)),
    retractall(id_counter(_, _)).

new_simulation_state(Spec, SimulationId) :-
    next_identifier(simulation, SimulationId),
    spec_field(Spec, name, Name, 'Business Simulation'),
    spec_field(Spec, currency, Currency, 'AUD'),
    spec_field(Spec, timezone, Timezone, 'UTC'),
    spec_field(Spec, time_ratio, TimeRatio, DefaultRatio),
    default_time_ratio(DefaultRatio),
    Clock = clock(
        datetime(2026, 1, 1, 9, 0, 0),
        TimeRatio,
        [],
        [],
        false
    ),
    State = simulation_state(
        metadata(metadata(Name, Currency, Timezone, 1)),
        clock(Clock),
        businesses([]),
        customers([]),
        offices([]),
        locations([]),
        environments([]),
        events([]),
        bookings([]),
        payments([]),
        employees([]),
        ledger([]),
        consent_records([]),
        audit_log([])
    ),
    put_simulation_state(SimulationId, State),
    set_active_simulation(SimulationId).

spec_field(simulation_spec(Fields), Key, Value, Default) :-
    !,
    (   memberchk(Term, Fields),
        Term =.. [Key, Candidate]
    ->  Value = Candidate
    ;   Value = Default
    ).
spec_field(Spec, Key, Value, Default) :-
    Spec =.. [simulation_spec | Fields],
    (   memberchk(Term, Fields),
        Term =.. [Key, Candidate]
    ->  Value = Candidate
    ;   Value = Default
    ).

get_simulation_state(SimulationId, State) :-
    must_be(atom, SimulationId),
    (   simulation_store(SimulationId, State)
    ->  true
    ;   throw(error(existence_error(simulation, SimulationId), _))
    ).

put_simulation_state(SimulationId, State) :-
    must_be(atom, SimulationId),
    retractall(simulation_store(SimulationId, _)),
    asserta(simulation_store(SimulationId, State)).

update_simulation_state(SimulationId, Goal, State) :-
    get_simulation_state(SimulationId, State0),
    call(Goal, State0, State),
    put_simulation_state(SimulationId, State).

set_active_simulation(SimulationId) :-
    must_be(atom, SimulationId),
    retractall(active_simulation_id(_)),
    asserta(active_simulation_id(SimulationId)).

active_simulation(SimulationId) :-
    (   active_simulation_id(SimulationId)
    ->  true
    ;   throw(error(existence_error(active_simulation, none), _))
    ).

current_simulation(SimulationId) :-
    active_simulation_id(SimulationId).

next_identifier(Prefix, Identifier) :-
    must_be(atom, Prefix),
    (   retract(id_counter(Prefix, Current))
    ->  Next is Current + 1
    ;   Next = 1
    ),
    asserta(id_counter(Prefix, Next)),
    format(atom(Identifier), '~w_~|~`0t~d~6+', [Prefix, Next]).

append_audit_entry(SimulationId, Actor, Action, Target, Result, State) :-
    get_simulation_state(SimulationId, State0),
    next_identifier(audit, AuditId),
    now_datetime(Now),
    term_hash(State0, BeforeHash),
    state_component(audit_log, State0, AuditLog0),
    Entry = audit_entry(
        AuditId,
        timestamp(Now),
        actor(Actor),
        action(Action),
        target(Target),
        before_hash(BeforeHash),
        after_hash(pending),
        result(Result)
    ),
    append(AuditLog0, [Entry], AuditLog1),
    set_state_component(audit_log, State0, AuditLog1, State1),
    term_hash(State1, AfterHash),
    update_last_audit_after_hash(AuditLog1, AfterHash, AuditLog2),
    set_state_component(audit_log, State1, AuditLog2, State),
    put_simulation_state(SimulationId, State).

update_last_audit_after_hash(AuditLog, AfterHash, Updated) :-
    append(Front, [audit_entry(Id, Ts, Actor, Action, Target, Before, after_hash(_), Res)], AuditLog),
    append(Front, [audit_entry(Id, Ts, Actor, Action, Target, Before, after_hash(AfterHash), Res)], Updated).

now_datetime(datetime(Y, M, D, HH, MM, SS)) :-
    get_time(Stamp),
    stamp_date_time(Stamp, date(Y, M, D, HH, MM, SSF, _, _, _), 'UTC'),
    SS is floor(SSF).

state_component(Component, State, Value) :-
    component_index(Component, Index),
    arg(Index, State, Wrapped),
    Wrapped =.. [_Tag, Value].

set_state_component(Component, State0, Value, State) :-
    component_index(Component, Index),
    State0 =.. [simulation_state | Args0],
    nth1(Index, Args0, OldWrapped),
    OldWrapped =.. [Tag, _],
    NewWrapped =.. [Tag, Value],
    replace_nth1(Args0, Index, NewWrapped, Args),
    State =.. [simulation_state | Args].

component_index(metadata, 1).
component_index(clock, 2).
component_index(businesses, 3).
component_index(customers, 4).
component_index(offices, 5).
component_index(locations, 6).
component_index(environments, 7).
component_index(events, 8).
component_index(bookings, 9).
component_index(payments, 10).
component_index(employees, 11).
component_index(ledger, 12).
component_index(consent_records, 13).
component_index(audit_log, 14).

replace_nth1([_ | Rest], 1, Value, [Value | Rest]) :- !.
replace_nth1([Head | Rest0], Index, Value, [Head | Rest]) :-
    Index > 1,
    Next is Index - 1,
    replace_nth1(Rest0, Next, Value, Rest).
