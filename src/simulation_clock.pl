:- module(simulation_clock, [
    elapsed_workdays/4,
    advance_clock/4,
    datetime_stamp/2
]).

:- use_module(library(error)).
:- use_module(library(date)).

elapsed_workdays(clock(datetime(Y0, M0, D0, _, _, _), _, Holidays, _, _), From, To, Days) :-
    datetime_stamp(From, FromStamp),
    datetime_stamp(To, ToStamp),
    (   ToStamp =< FromStamp
    ->  Days = 0
    ;   date_stamp(date(Y0, M0, D0), _),
        elapsed_days_between(From, To, Holidays, 0, Days)
    ).

advance_clock(Clock0, Target, Clock, advanced(workdays(Workdays))) :-
    Clock0 = clock(Current, Ratio, Holidays, ProcessedTargets0, Paused),
    (   memberchk(Target, ProcessedTargets0)
    ->  Clock = Clock0,
        Workdays = 0
    ;   (Paused == true -> Workdays = 0 ; elapsed_workdays(Clock0, Current, Target, Workdays)),
        append(ProcessedTargets0, [Target], ProcessedTargets),
        Clock = clock(Target, Ratio, Holidays, ProcessedTargets, Paused)
    ).

elapsed_days_between(datetime(Y1, M1, D1, _, _, _), datetime(Y2, M2, D2, _, _, _), Holidays, Acc, Days) :-
    date_stamp(date(Y1, M1, D1), S1),
    date_stamp(date(Y2, M2, D2), S2),
    (   S1 >= S2
    ->  Days = Acc
    ;   next_date(date(Y1, M1, D1), NextDate),
        (   is_workday(NextDate, Holidays)
        ->  Acc1 is Acc + 1
        ;   Acc1 = Acc
        ),
        NextDate = date(NY, NM, ND),
        elapsed_days_between(datetime(NY, NM, ND, 0, 0, 0), datetime(Y2, M2, D2, 0, 0, 0), Holidays, Acc1, Days)
    ).

is_workday(date(Y, M, D), Holidays) :-
    day_of_the_week(date(Y, M, D), DayOfWeek),
    DayOfWeek \= 6,
    DayOfWeek \= 7,
    \+ memberchk(date(Y, M, D), Holidays).

next_date(date(Y, M, D), date(NY, NM, ND)) :-
    date_time_stamp(date(Y, M, D, 12, 0, 0, 0, -, -), Stamp),
    NextStamp is Stamp + 86400,
    stamp_date_time(NextStamp, date(NY, NM, ND, _, _, _, _, _, _), 'UTC').

date_stamp(date(Y, M, D), Stamp) :-
    date_time_stamp(date(Y, M, D, 0, 0, 0, 0, -, -), Stamp).

datetime_stamp(datetime(Y, M, D, HH, MM, SS), Stamp) :-
    must_be(integer, Y),
    must_be(integer, M),
    must_be(integer, D),
    must_be(integer, HH),
    must_be(integer, MM),
    must_be(integer, SS),
    date_time_stamp(date(Y, M, D, HH, MM, SS, 0, -, -), Stamp).
