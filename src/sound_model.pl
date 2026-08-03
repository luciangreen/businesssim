:- module(sound_model, [
    validate_noise_plan/2
]).

validate_noise_plan(sound_plan(Fields), valid) :-
    memberchk(noise_escape_rating(low), Fields),
    !.
validate_noise_plan(sound_plan(Fields), warning(noise_may_escape)) :-
    memberchk(noise_escape_rating(medium), Fields),
    !.
validate_noise_plan(sound_plan(_), invalid(noise_plan_missing_controls)).

