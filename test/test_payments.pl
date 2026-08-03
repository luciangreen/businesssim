:- begin_tests(payments).

:- use_module('../src/payment_model').

test(rejects_raw_card_data, [fail]) :-
    valid_payment_spec(payment_spec([amount(45.0), currency('AUD'), raw_card_number('4111111111111111'), external_reference('x')])).

test(accepts_external_reference_only) :-
    valid_payment_spec(payment_spec([amount(45.0), currency('AUD'), external_reference('provider_ref_1')])).

:- end_tests(payments).

