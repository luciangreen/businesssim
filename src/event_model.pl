:- module(event_model, [
    valid_concert_spec/1,
    create_event_term/4,
    event_field/3
]).

:- use_module(library(error)).

valid_concert_spec(concert_spec(Fields)) :-
    memberchk(title(Title), Fields),
    must_be(atom, Title),
    memberchk(ticket_price(Price), Fields),
    must_be(number, Price),
    Price >= 0.

create_event_term(EventId, BusinessId, concert_spec(Fields), event(EventId, BusinessId, concert_spec(Fields), event_state(scheduled, 0, 0, 0, 0, 0))).

event_field(event(_, _, concert_spec(Fields), _), Key, Value) :-
    member(Term, Fields),
    Term =.. [Key, Value].
