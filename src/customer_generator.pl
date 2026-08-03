:- module(customer_generator, [
    generate_customers_from_profile/3
]).

:- use_module(library(error)).

generate_customers_from_profile(customer_profile(Fields), Seed, Customers) :-
    memberchk(count(Count), Fields),
    must_be(nonneg, Count),
    findall(
        generated_customer(Index, Seed, Fields),
        between(1, Count, Index),
        Customers
    ).

