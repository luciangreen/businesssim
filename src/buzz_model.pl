:- module(buzz_model, [
    forecast_buzz_score/3,
    actual_buzz_score/3,
    simulated_buzz_score/3
]).

forecast_buzz_score(BusinessId, period(Start, End), buzz_score(BusinessId, forecast, Start, End, 50)).
actual_buzz_score(BusinessId, period(Start, End), buzz_score(BusinessId, actual, Start, End, 0)).
simulated_buzz_score(BusinessId, period(Start, End), buzz_score(BusinessId, simulated, Start, End, 100)).

