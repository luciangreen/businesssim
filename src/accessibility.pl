:- module(accessibility, [
    accessibility_check/3
]).

accessibility_check(EventId, CustomerNeeds, compatible(EventId, CustomerNeeds)) :-
    is_list(CustomerNeeds).

