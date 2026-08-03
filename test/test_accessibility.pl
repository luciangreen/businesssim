:- begin_tests(accessibility).

:- use_module('../src/accessibility').

test(accessibility_check_returns_compatible) :-
    accessibility_check(event_000001, [captions, reduced_motion_mode], compatible(event_000001, [captions, reduced_motion_mode])).

:- end_tests(accessibility).

