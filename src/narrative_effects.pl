:- module(narrative_effects, [
    create_effect/1,
    create_transition/1,
    time_compression_option/2
]).

create_effect(actual_memory_implantation) :-
    throw(error(prohibited_operation(actual_memory_manipulation), _)).
create_effect(fictional_recollection_sequence).

create_transition(real_teleportation) :-
    throw(error(prohibited_operation(real_teleportation), _)).
create_transition(simulated_teleportation_scene_transition).

time_compression_option(EventId, time_compression_option(
    EventId,
    mode(skip_to_finale),
    customer_controlled(true),
    disclosure(explicit)
)).

