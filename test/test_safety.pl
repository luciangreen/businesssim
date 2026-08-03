:- begin_tests(safety).

:- use_module('../src/compliance').
:- use_module('../src/narrative_effects').

test(actual_memory_manipulation_rejected, [throws(error(prohibited_operation(actual_memory_manipulation), _))]) :-
    permit_actual_memory_manipulation(anything).

test(real_teleportation_rejected, [throws(error(prohibited_operation(real_teleportation), _))]) :-
    create_transition(real_teleportation).

:- end_tests(safety).

