:- module(safety, [
    ensure_no_blocking_findings/1,
    blocking_finding/1
]).

blocking_finding(finding(severity(blocking), _, _, _, _)).
blocking_finding(finding(severity(emergency), _, _, _, _)).

ensure_no_blocking_findings(Findings) :-
    (   member(Finding, Findings),
        blocking_finding(Finding)
    ->  throw(error(blocking_finding(Finding), _))
    ;   true
    ).

