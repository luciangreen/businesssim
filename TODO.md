# Remaining Implementation Work

This list tracks gaps against `pr1.txt`; it is not a promise that every future
extension in that specification will be delivered in one change.

## Core simulation

- [ ] Complete business/customer/office lifecycle and validate references
  between businesses, locations, employees, customers, and events.
- [ ] Add business calendars, weekends/holidays, timezone and daylight-saving
  handling, closures, pauses, and corrections to the clock.
- [ ] Process work schedules and operational events during clock advancement.
- [ ] Complete customer decision, satisfaction, repeat-attendance, and buzz
  simulation with reproducible seeded state transitions.

## Events, consent, and safety

- [ ] Complete event scheduling fields, performers/rights, virtual sets,
  acoustic modes, virtual walls, and scene transitions.
- [ ] Implement consent creation, policy versioning, withdrawal, and optional
  effect/accessibility choices end to end.
- [ ] Validate physical emergency arrangements and enforce blocking findings
  before ticket sale/admission/event activation.
- [ ] Complete ticket validation/scanning, refund lifecycle, remote attendance,
  and cancellation handling.

## Finance, reporting, and persistence

- [ ] Add expense, wage, payment-fee, tax-estimate, refund-liability, and
  reconciliation flows; report complete profit and cash balances.
- [ ] Complete report fields while preserving separate actual, simulated,
  estimated, forecast, and user-supplied metrics.
- [ ] Add state format versioning, validation, and migration for saved scenarios.

## Interfaces and validation

- [ ] Expand the REPL to support customers, venues, events, tickets, payments,
  reports, and persistence operations.
- [ ] Expand required tests for calendar/DST, consent withdrawal, duplicate or
  invalid tickets, refunds, ledger balancing, accessibility, and blocked event
  admission.
- [ ] Run the SWI-Prolog suite locally and in CI after each implementation
  increment.

Future extensions such as browser UI, external ticket/payment integrations,
multiplayer simulation, and tax plugins are out of scope for the current core.
