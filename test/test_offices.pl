:- begin_tests(offices).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').

test(create_office) :-
    reset_engine,
    new_simulation(simulation_spec([name('Office Simulation')]), _),
    create_business(business_spec([name('Office Biz'), type(services), manager(manager_001)]), BusinessId),
    create_office(
        BusinessId,
        office_spec([staff_capacity(4), physical_customer_capacity(12), virtual_customer_capacity(500)]),
        OfficeId
    ),
    assertion(sub_atom(OfficeId, 0, _, _, office_)).

:- end_tests(offices).

