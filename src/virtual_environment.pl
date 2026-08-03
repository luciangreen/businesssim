:- module(virtual_environment, [
    create_environment_term/3,
    virtual_apparent_capacity/2
]).

create_environment_term(EnvironmentId, environment_spec(Fields), environment(EnvironmentId, environment_spec(Fields))).

virtual_apparent_capacity(environment_spec(Fields), Capacity) :-
    (   memberchk(apparent_capacity(Capacity), Fields)
    ->  true
    ;   Capacity = 0
    ).

