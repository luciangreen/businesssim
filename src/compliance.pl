:- module(compliance, [
    compliance_check/2,
    load_policy_profile/1,
    permit_actual_memory_manipulation/1,
    permit_nonconsensual_psychological_effect/1,
    permit_false_physical_venue_claim/1,
    permit_fake_real_customer_review/1,
    permit_hidden_exit_restriction/1,
    permit_unlicensed_real_person_impersonation/1,
    permit_payment_for_known_nonexistent_event/1,
    permit_simulated_attendee_as_real_attendee/1
]).

:- use_module(simulation_engine).

:- dynamic loaded_policy_profile/1.

load_policy_profile(Profile) :-
    retractall(loaded_policy_profile(_)),
    asserta(loaded_policy_profile(Profile)).

compliance_check(EventId, Findings) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State),
    state_component(events, State, Events),
    (   member(event(EventId, BusinessId, concert_spec(Fields), _), Events)
    ->  event_findings(BusinessId, Fields, Findings0),
        (loaded_policy_profile(_) -> Findings = Findings0 ; append(Findings0, [finding(severity(information), code(policy_profile_not_loaded), description('Policy profile not loaded'), evidence(EventId), suggested_action(load_policy_profile))], Findings))
    ;   Findings = [
            finding(
                severity(blocking),
                code(event_not_found),
                description('Event not found'),
                evidence(EventId),
                suggested_action(create_event)
            )
        ]
    ).

event_findings(BusinessId, Fields, Findings) :-
    findall(
        Finding,
        required_finding(BusinessId, Fields, Finding),
        Findings
    ).

required_finding(_, Fields, finding(severity(blocking), code(no_physical_host_location), description('Missing physical host location'), evidence(Fields), suggested_action(add_physical_location))) :-
    \+ memberchk(physical_location(_), Fields).
required_finding(_, Fields, finding(severity(blocking), code(missing_refund_terms), description('Missing refund terms'), evidence(Fields), suggested_action(add_refund_terms))) :-
    \+ memberchk(refund_terms(_), Fields).
required_finding(_, Fields, finding(severity(blocking), code(missing_disclosure_policy), description('Missing disclosure terms'), evidence(Fields), suggested_action(add_disclosures))) :-
    \+ memberchk(disclosures(_), Fields).
required_finding(BusinessId, _, finding(severity(blocking), code(no_responsible_manager), description('Business manager not found'), evidence(BusinessId), suggested_action(assign_manager))) :-
    active_simulation(SimulationId),
    get_simulation_state(SimulationId, State),
    state_component(businesses, State, Businesses),
    (   member(business(BusinessId, business_spec(BusinessFields)), Businesses)
    ->  \+ memberchk(manager(_), BusinessFields)
    ;   true
    ).

permit_actual_memory_manipulation(_) :-
    throw(error(prohibited_operation(actual_memory_manipulation), _)).
permit_nonconsensual_psychological_effect(_) :-
    throw(error(prohibited_operation(nonconsensual_psychological_effect), _)).
permit_false_physical_venue_claim(_) :-
    throw(error(prohibited_operation(false_physical_venue_claim), _)).
permit_fake_real_customer_review(_) :-
    throw(error(prohibited_operation(fake_real_customer_review), _)).
permit_hidden_exit_restriction(_) :-
    throw(error(prohibited_operation(hidden_exit_restriction), _)).
permit_unlicensed_real_person_impersonation(_) :-
    throw(error(prohibited_operation(unlicensed_real_person_impersonation), _)).
permit_payment_for_known_nonexistent_event(_) :-
    throw(error(prohibited_operation(payment_for_known_nonexistent_event), _)).
permit_simulated_attendee_as_real_attendee(_) :-
    throw(error(prohibited_operation(simulated_attendee_as_real_attendee), _)).
