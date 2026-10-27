# Command Reference

Start the REPL with:

```bash
swipl -q -s src/business_suite.pl -g start_repl
```

Commands:

- `new simulation <name>`
- `create business <name>`
- `help`
- `quit`

Names may contain spaces. Creating a business requires an active simulation;
businesses created by this minimal REPL use the `small_business` type and the
`repl_manager` manager. The REPL reports that requirement without terminating
when no simulation is active.

The DCG parser is in `src/command_parser.pl`; command execution is in
`src/repl.pl`. This interface currently covers only the commands listed above.
