:- module(staffing, [
    assign_shift/6,
    detect_overlapping_shifts/2
]).

assign_shift(EmployeeId, BusinessId, Role, starts_at(Start), ends_at(End), shift(EmployeeId, BusinessId, Role, Start, End)).

detect_overlapping_shifts(Shifts, overlap(EmployeeA, EmployeeB)) :-
    member(shift(EmployeeA, _, _, StartA, EndA), Shifts),
    member(shift(EmployeeB, _, _, StartB, EndB), Shifts),
    EmployeeA \= EmployeeB,
    StartA @< EndB,
    StartB @< EndA,
    !.

