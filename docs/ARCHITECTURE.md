# Architecture

`business_suite.pl` is the public API entrypoint. It coordinates:

- `simulation_engine.pl` for simulation storage, active simulation context, IDs, and audit entries.
- `simulation_clock.pl` for elapsed workday progression and idempotent advancement.
- domain modules (`business_registry`, `customer_model`, `location_model`, `event_model`, `ticketing`, `payment_model`, `accounting`, `compliance`, `reporting`) for validation and term shaping.
- `persistence.pl` for save/load of serialized simulation terms.
- `command_parser.pl` and `repl.pl` for CLI interaction.

State is stored as explicit `simulation_state(...)` terms and updated via state component replacement, preserving serializability and deterministic replay.

