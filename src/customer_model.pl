:- module(customer_model, [
    valid_customer_spec/1,
    create_customer_term/3
]).

:- use_module(library(error)).

valid_customer_spec(customer_spec(Fields)) :-
    memberchk(name(Name), Fields),
    must_be(atom, Name).
valid_customer_spec(customer_profile(Fields)) :-
    memberchk(count(Count), Fields),
    must_be(nonneg, Count).

create_customer_term(CustomerId, customer_spec(Fields), customer(CustomerId, customer_spec(Fields), simulated(false))).
create_customer_term(CustomerId, customer_profile(Fields), customer(CustomerId, customer_profile(Fields), simulated(true))).

