:- module(booking_model, [
    booking_term/6
]).

booking_term(BookingId, EventId, CustomerId, Amount, Status, booking(BookingId, EventId, CustomerId, Amount, Status)).

