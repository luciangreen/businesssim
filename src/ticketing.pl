:- module(ticketing, [
    issue_ticket_term/5,
    validate_ticket_record/4,
    mark_ticket_admitted/3
]).

issue_ticket_term(TicketId, BookingId, EventId, Status, ticket(TicketId, BookingId, EventId, Status, admission(not_scanned))).

validate_ticket_record(ticket(_, _, EventId, active, admission(not_scanned)), EventId, valid, ok) :- !.
validate_ticket_record(ticket(_, _, _, refunded, _), _, invalid, refunded_ticket) :- !.
validate_ticket_record(ticket(_, _, EventId, active, admission(scanned)), EventId, invalid, duplicate_scan) :- !.
validate_ticket_record(ticket(_, _, WrongEvent, active, _), EventId, invalid, wrong_event(WrongEvent, EventId)).

mark_ticket_admitted(ticket(Id, BookingId, EventId, Status, _), CheckpointId, ticket(Id, BookingId, EventId, Status, admission(scanned_at(CheckpointId)))).

