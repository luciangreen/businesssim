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

## Repository structure

- `src/` Prolog modules for simulation, compliance, reporting, persistence, and REPL.
- `test/` PlUnit test suite.
- `docs/` Architecture, model, API, command, and safety documentation.
