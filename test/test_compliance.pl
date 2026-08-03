:- begin_tests(compliance).

:- use_module('../src/business_suite').
:- use_module('../src/simulation_engine').
:- use_module('../src/compliance', [load_policy_profile/1]).

test(missing_disclosure_is_blocking) :-
    reset_engine,
    new_simulation(simulation_spec([name('Compliance Simulation')]), _),
    create_business(business_spec([name('Comp Biz'), type(virtual_entertainment), manager(manager_001)]), BusinessId),
    create_physical_location(location_spec([address('Safety Rd'), maximum_occupancy(12)]), LocationId),
    create_virtual_environment(environment_spec([apparent_capacity(500), uri('virtual://comp')]), EnvironmentId),
    schedule_concert(
        BusinessId,
        concert_spec([
            title('Compliance Night'),
            physical_location(LocationId),
            environment(EnvironmentId),
            virtual_address('virtual://comp'),
            ticket_price(45.0),
            refund_terms(standard_refunds)
        ]),
        EventId
    ),
    compliance_check(EventId, Findings),
    member(finding(severity(blocking), code(missing_disclosure_policy), _, _, _), Findings).

test(policy_profile_can_load) :-
    load_policy_profile(australia_general_entertainment).

:- end_tests(compliance).
