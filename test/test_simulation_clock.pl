:- begin_tests(simulation_clock).

:- use_module('../src/simulation_clock').

test(one_real_day_one_workday) :-
    Clock = clock(datetime(2026, 8, 10, 9, 0, 0), time_ratio(real_days(1), simulation_workdays(1)), [], [], false),
    elapsed_workdays(Clock, datetime(2026, 8, 10, 9, 0, 0), datetime(2026, 8, 11, 9, 0, 0), Days),
    assertion(Days =:= 1).

test(idempotent_advance) :-
    Clock0 = clock(datetime(2026, 8, 10, 9, 0, 0), time_ratio(real_days(1), simulation_workdays(1)), [], [], false),
    advance_clock(Clock0, datetime(2026, 8, 11, 9, 0, 0), Clock1, _),
    advance_clock(Clock1, datetime(2026, 8, 11, 9, 0, 0), Clock2, advanced(workdays(Workdays))),
    assertion(Workdays =:= 0),
    assertion(Clock2 == Clock1).

:- end_tests(simulation_clock).

