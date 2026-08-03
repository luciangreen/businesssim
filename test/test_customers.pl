:- begin_tests(customers).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(create_customer) :-
    reset_engine,
    new_simulation(simulation_spec([name('Customer Simulation')]), _),
    create_customer(customer_spec([name(alex)]), CustomerId),
    assertion(sub_atom(CustomerId, 0, _, _, customer_)).

test(generate_customers_count) :-
    reset_engine,
    new_simulation(simulation_spec([name('Customer Generation')]), _),
    generate_customers(customer_profile([count(3), interests([live_music])]), CustomerIds),
    length(CustomerIds, 3).

:- end_tests(customers).

