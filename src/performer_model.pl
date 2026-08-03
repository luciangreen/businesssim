:- module(performer_model, [
    performer_type/1,
    validate_performer_rights/2
]).

performer_type(real_person).
performer_type(licensed_recording).
performer_type(authorised_avatar).
performer_type(fictional_simulation).
performer_type(procedural_music).
performer_type(hybrid).

validate_performer_rights(performer_spec(real_person, Fields), valid) :-
    memberchk(permission_evidence(_), Fields),
    !.
validate_performer_rights(performer_spec(real_person, _), invalid(missing_permission_evidence)) :- !.
validate_performer_rights(performer_spec(Type, _), valid) :-
    performer_type(Type).

