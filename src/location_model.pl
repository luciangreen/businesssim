:- module(location_model, [
    valid_location_spec/1,
    physical_capacity_from_location/2
]).

:- use_module(library(error)).

valid_location_spec(location_spec(Fields)) :-
    memberchk(address(Address), Fields),
    must_be(atom, Address),
    memberchk(maximum_occupancy(Max), Fields),
    must_be(nonneg, Max).

physical_capacity_from_location(location_spec(Fields), Capacity) :-
    memberchk(maximum_occupancy(Capacity), Fields).

