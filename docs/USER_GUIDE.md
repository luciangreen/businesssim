# User Guide

Install SWI-Prolog (`swipl`) before running commands below. On Debian/Ubuntu,
install it with `sudo apt-get install swi-prolog-nox`. Run the following from
the repository root.

## 1. Run tests

```bash
swipl -q -s test/test_runner.pl -g run_tests -t halt
```

For the focused REPL tests, run:

```bash
swipl -q -s test/test_repl.pl -g "run_tests(repl)" -t halt
```

`docs/FEATURES_AND_TESTS.md` lists the test files and their coverage. The test
runner also supports selecting a test unit by name.

## 2. Run demo

```bash
swipl -q -s src/business_suite.pl -g run_demo -t halt
```

The demo creates an in-memory simulation and prints an event report. It does
not connect to real payment providers or event platforms.

## 3. Use interactive REPL

```bash
swipl -q -s src/business_suite.pl -g start_repl
```

Use `help` to list commands. `new simulation <name>` creates and activates a
simulation; `create business <name>` registers a business in that active
simulation. Type `quit` or send EOF to exit. See
`docs/COMMAND_REFERENCE.md` for command behavior and current limitations.

## 4. Prolog API

`business_suite` exports simulation creation and persistence, business and
customer creation, office and location creation, concert scheduling,
ticketing, door payments, clock advancement, scenario simulation, compliance
checks, business/event reports, and the REPL/demo entrypoints. See
`docs/PROLOG_API.md` for predicate signatures and a runnable example in the
repository `README.md`.

## 5. More documentation

- `docs/FEATURES_AND_TESTS.md`: feature status, test coverage, and commands.
- `docs/ARCHITECTURE.md`: module boundaries and state model.
- `docs/SIMULATION_MODEL.md`: state shape and truthful metric labels.
- `docs/SAFETY_AND_CONSENT.md`: simulation safety and consent boundaries.
- `docs/EXAMPLE_SCENARIOS.md`: demonstration scenario.
- `TODO.md`: implementation gaps and suggested next steps.
