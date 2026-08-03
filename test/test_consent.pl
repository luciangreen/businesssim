:- begin_tests(consent).

:- use_module('../src/consent_model').

test(valid_consent_record) :-
    valid_consent_record(
        customer_consent(
            consent_000001,
            customer(customer_000001),
            event(event_000001),
            disclosures([virtual_environment, fictional_recollection]),
            accepted_at(datetime(2026, 8, 10, 18, 0, 0)),
            version(v1)
        )
    ).

:- end_tests(consent).

