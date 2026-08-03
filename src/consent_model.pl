:- module(consent_model, [
    valid_consent_record/1,
    consent_withdrawn/2
]).

valid_consent_record(customer_consent(_, customer(_), event(_), disclosures(Disclosures), accepted_at(_), version(_))) :-
    is_list(Disclosures),
    Disclosures \= [].

consent_withdrawn(ConsentId, consent_withdrawn(ConsentId, true)).

