# businesssim

Business Simulation Suite in SWI-Prolog for deterministic small-business event simulation with explicit separation of physical and virtual experience metrics.

## Quick start

```bash
swipl -q -s test/test_runner.pl -g run_tests -t halt
```

Run the demonstration scenario:

```bash
swipl -q -s src/business_suite.pl -g run_demo -t halt
```

## Example commands

### 1. Run the full test suite

```bash
swipl -q -s test/test_runner.pl -g run_tests -t halt
```

### 2. Run the built-in demo scenario (The Infinite Parlour)

```bash
swipl -q -s src/business_suite.pl -g run_demo -t halt
```

### 3. Start the interactive REPL

```bash
swipl -q -s src/business_suite.pl -g start_repl
```

Once inside the REPL, type any of the following commands:

```
business-suite> help
business-suite> new simulation My Cafe
business-suite> create business Corner Cafe
business-suite> quit
```

### 4. Prolog API — build a simulation from scratch

Load the suite and run a complete scenario interactively or in a script:

```prolog
:- use_module('src/business_suite').
:- use_module('src/compliance', [load_policy_profile/1]).

example :-
    % Create a new simulation
    new_simulation(
        simulation_spec([
            name('My First Simulation'),
            currency('AUD'),
            timezone('Australia/Melbourne'),
            time_ratio(time_ratio(real_days(1), simulation_workdays(1)))
        ]),
        SimulationId
    ),

    % Register a business
    create_business(
        business_spec([
            name('Corner Cafe'),
            type(cafe),
            manager(manager_001)
        ]),
        BusinessId
    ),

    % Create a small physical venue
    create_physical_location(
        location_spec([
            address('1 Main Street'),
            maximum_occupancy(50)
        ]),
        LocationId
    ),

    % Create a virtual streaming environment
    create_virtual_environment(
        environment_spec([
            apparent_capacity(1000),
            uri('virtual://corner-cafe-stream')
        ]),
        EnvId
    ),

    % Schedule a concert with disclosures and refund terms
    schedule_concert(
        BusinessId,
        concert_spec([
            title('Live at Corner Cafe'),
            physical_location(LocationId),
            environment(EnvId),
            virtual_address('virtual://corner-cafe-stream'),
            ticket_price(25.0),
            performer(local_band),
            disclosures([virtual_environment, simulated_fans]),
            refund_terms(standard_refund_policy)
        ]),
        EventId
    ),

    % Run a compliance check (blocks on severity findings)
    load_policy_profile(australia_general_entertainment),
    compliance_check(EventId, Findings),
    format('Compliance findings: ~q~n', [Findings]),

    % Record a door payment
    record_door_payment(EventId, customer_walk_in, cash, 25.0, _ReceiptId),

    % Advance the simulation clock
    advance_simulation(SimulationId, datetime(2026, 8, 10, 23, 59, 59), _),

    % Print the event report
    event_report(EventId, Report),
    portray_clause(Report).
```

Run this script with:

```bash
swipl -q -s src/business_suite.pl -g example -t halt
```

### 5. Save and reload simulation state

```prolog
% Save current simulation to a file
save_simulation(SimulationId, 'my_sim.state'),

% Load it back in a later session
load_simulation('my_sim.state', RestoredSimulationId).
```

### 6. Generate a business report

```prolog
business_report(BusinessId, period(2026, august), Report),
portray_clause(Report).
```

## Repository structure

- `src/` Prolog modules for simulation, compliance, reporting, persistence, and REPL.
- `test/` PlUnit test suite.
- `docs/` Architecture, model, API, command, and safety documentation.
