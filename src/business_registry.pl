:- module(business_registry, [
    valid_business_spec/1,
    create_business_in_state/4,
    find_business/3
]).

:- use_module(library(error)).
:- use_module(simulation_engine).

valid_business_spec(business_spec(Fields)) :-
    must_have_field(Fields, name),
    must_have_field(Fields, type),
    must_have_field(Fields, manager).

must_have_field(Fields, Key) :-
    (   member(Term, Fields),
        Term =.. [Key, Value],
        nonvar(Value)
    ->  true
    ;   throw(error(validation_error(field(Key), reason(required)), _))
    ).

create_business_in_state(SimulationId, Spec, BusinessId, State) :-
    valid_business_spec(Spec),
    get_simulation_state(SimulationId, State0),
    next_identifier(business, BusinessId),
    state_component(businesses, State0, Businesses0),
    append(Businesses0, [business(BusinessId, Spec)], Businesses),
    set_state_component(businesses, State0, Businesses, State),
    put_simulation_state(SimulationId, State).

find_business(SimulationId, Query, Business) :-
    get_simulation_state(SimulationId, State),
    state_component(businesses, State, Businesses),
    member(Business, Businesses),
    business_matches(Query, Business).

business_matches(id(Id), business(Id, _)).
business_matches(name(Name), business(_, business_spec(Fields))) :-
    memberchk(name(Name), Fields).
