# Features and Tests

This document describes what is implemented in this repository today. The
canonical design requirements are in `pr1.txt`; this status is deliberately
more conservative than that full specification.

## Feature status

| Area | Status | Current behavior |
|---|---|---|
| Simulation state and IDs | Implemented | In-memory simulation state, active simulation, identifiers, and audit entries. |
| Business, customer, office, and venue records | Partial | Create operations and basic validation exist; there is no complete business lifecycle or domain-wide referential validation. |
| Time progression | Partial | Configurable ratio, elapsed-workday calculations, and advancement exist; calendars, holidays, closures, timezone/DST rules, pauses, and downstream work processing are incomplete. |
| Physical and virtual venues | Partial | Separate physical occupancy and apparent virtual capacity are represented; virtual addresses, walls, and complete emergency/accessibility models are incomplete. |
| Events and concerts | Partial | Concert creation, event reports, ticket sales, and door receipts exist; many required performer, schedule, and event-operation features remain. |
| Consent and narrative effects | Partial | Consent/disclosure terms and safety checks exist; a complete consent lifecycle and user-selectable effects are not implemented. |
| Ticketing and payments | Partial | Ticket and door-payment records are created and audited; scanning, refunds, remote admissions, and payment-provider integrations are not complete. |
| Accounting | Partial | Ledger entries and revenue/reporting exist; complete expenses, fees, tax, liabilities, reconciliation, and profit calculations remain. |
| Compliance and safety | Partial | Policy-profile checks and blocking findings are present; jurisdictional coverage and admission/activation enforcement are incomplete. |
| Accessibility | Partial | Basic accessibility checks are available; the complete event/customer-needs flow and physical evacuation validation are not present. |
| Persistence | Partial | Scenario state can be saved and loaded; schema/version migration and robust persistence validation remain. |
| Deterministic scenarios | Partial | A deterministic seeded example result and scenario test exist; full agent-based repeatable business operations are not implemented. |
| CLI | Partial | REPL supports help, creating a simulation, and creating a business; other management, event, reporting, and persistence commands are not implemented. |
| Documentation and CI | Implemented | User/API/architecture/model/safety/command docs, PlUnit runner, and CI workflow are present. |

No current feature integrates with real payment processing, ticketing providers,
or real customer identity systems. Virtual crowd counts are simulated values,
not actual attendance.

## Test commands

Install SWI-Prolog, then run these from the repository root.

Full suite (also the CI command):

```bash
swipl -q -s test/test_runner.pl -g run_tests -t halt
```

Run one test unit:

```bash
swipl -q -s test/test_repl.pl -g "run_tests(repl)" -t halt
swipl -q -s test/test_runner.pl -g "run_tests(simulation_clock)" -t halt
swipl -q -s test/test_runner.pl -g "run_tests(ticketing)" -t halt
```

Run the demonstration:

```bash
swipl -q -s src/business_suite.pl -g run_demo -t halt
```

The test units currently loaded by `test/test_runner.pl` are:

| Test file | Coverage |
|---|---|
| `test_business_registry.pl` | Business creation |
| `test_simulation_clock.pl` | Clock ratios, progression, and repeat advancement |
| `test_customers.pl` | Customer creation and generation |
| `test_offices.pl` | Office creation |
| `test_locations.pl` | Physical location validation |
| `test_virtual_environments.pl` | Virtual capacity/environment records |
| `test_concerts.pl` | Concert validation and creation |
| `test_consent.pl` | Consent/disclosure checks |
| `test_ticketing.pl` | Ticket sales and physical capacity |
| `test_payments.pl` | Payment record construction |
| `test_accounting.pl` | Ledger and financial report behavior |
| `test_compliance.pl` | Compliance findings |
| `test_safety.pl` | Prohibited and unsafe operations |
| `test_accessibility.pl` | Accessibility checks |
| `test_repl.pl` | REPL parsing and command effects |
| `test_persistence.pl` | Save/load round trip |
| `test_scenarios.pl` | End-to-end demo flow and seeded reproducibility |

The tests are unit and in-memory scenario tests. They do not certify legal
compliance, connect to external services, or replace venue-specific safety
reviews.
