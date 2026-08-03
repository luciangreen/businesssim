# Simulation Model

Core state shape:

```prolog
simulation_state(
    metadata(_),
    clock(_),
    businesses(_),
    customers(_),
    offices(_),
    locations(_),
    environments(_),
    events(_),
    bookings(_),
    payments(_),
    employees(_),
    ledger(_),
    consent_records(_),
    audit_log(_)
).
```

The model labels report values as `actual`, `simulated`, `forecast`, `estimated`, or `user_supplied`, and never aliases simulated crowd counts as actual attendance.

