:- module(payment_model, [
    valid_payment_spec/1,
    payment_request_term/8
]).

:- use_module(library(error)).

valid_payment_spec(payment_spec(Fields)) :-
    memberchk(amount(Amount), Fields),
    must_be(number, Amount),
    Amount >= 0,
    memberchk(external_reference(_), Fields),
    \+ memberchk(raw_card_number(_), Fields).

payment_request_term(PaymentId, CustomerId, BusinessId, Amount, Currency, Purpose, ExternalReference, payment_request(
    PaymentId,
    payer(CustomerId),
    payee(BusinessId),
    amount(Amount),
    currency(Currency),
    purpose(Purpose),
    external_reference(ExternalReference)
)).

