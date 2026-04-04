# shcli

`shcli` is a tiny, dependency-free Bash helper that turns a single script into a small, colorful command-line app. It registers commands and flags, parses long options, and exports their values as environment variables so your functions can read input without manually handling `$@`.

- **Zero dependencies**: Pure Bash (arrays only; no associative arrays), works on older shells.
- **Command + flag registry**: Define commands, global flags, and command-specific flags with help text and defaults.
- **Environment export**: Every flag value is exported as `CLI_ARG_<UPPERCASE_NAME>` for direct use in functions.
- **Colorful help**: Auto-generated usage with colorized sections for commands and flags.
- **Tested examples**: The repo includes runnable examples and a small test suite.

## Installation
Source `cli.sh` from your Bash script. No packaging is required.

```bash
#!/usr/bin/env bash
source /path/to/cli.sh
```

For local development inside this repo, source `./cli.sh` from the project root or copy it next to your script.

## Core concepts
- **Commands**: Named entry points (e.g., `deploy`, `ping`). If no command is provided, `cli_run` will fall back to a user-defined `main()` when present.
- **Global flags**: Options that apply to all commands (e.g., `--verbose`).
- **Command flags**: Options that apply only to a specific command (e.g., `deploy --env=prod`).
- **Environment export**: After parsing, each flag value is exported as `CLI_ARG_<UPPERCASE_FLAG_NAME>` so you can reference it in your functions without additional parsing.

## Quickstart examples
### Single-entry script using `main()`
```bash
#!/usr/bin/env bash
source ./cli.sh

main() {
    echo "Hello, ${CLI_ARG_NAME}!"
}

add_arg name "world" "Who to greet"

cli_run "$@"
```

Run it:
```bash
./hello.sh --name=Sam
# -> Hello, Sam!
```

### Command-based script with command-specific flags
```bash
#!/usr/bin/env bash
source ./cli.sh

ping() {
    echo "PONG latency=${CLI_ARG_LATENCY}ms quiet=${CLI_ARG_QUIET}"
}

add_cmd ping "Responds with PONG"
add_cmd_arg ping latency "100" "Artificial latency in ms"
add_cmd_arg ping quiet false "Mute extra output"

cli_run "$@"
```

Run help and commands:
```bash
./tool.sh --help          # global help with commands listed
./tool.sh ping --help     # help for the ping command
./tool.sh ping --latency=250 --quiet
```

## API reference
### `add_arg <name> <default> <help>`
Registers a global flag. The default is exported immediately to `CLI_ARG_<UPPERCASE_NAME>`.

- Access inside functions as `${CLI_ARG_<UPPERCASE_NAME>}`.
- Flags accept `--name=value` or `--name value` (the latter after quoting in your shell). If a flag appears without a value (e.g., `--verbose`), the stored value becomes `true`.
- Unknown flags are treated as positional arguments and forwarded unchanged to your command function.

### `add_cmd <name> <help>`
Registers a command. When `cli_run` sees the command token, it dispatches to a function of the same name with any remaining positional arguments.

### `add_cmd_arg <command> <name> <default> <help>`
Registers a flag that only applies to a specific command.

- Defaults are exported to `CLI_ARG_<UPPERCASE_NAME>` right before the command runs.
- Parsing behavior mirrors `add_arg` (supports `--flag=value` or `--flag value`, and `--flag` alone becomes `true`).

### `cli_run "$@"`
Entry point that must be the last line of your script.

- Parses argv in order, detects help flags, assigns flag values, and forwards remaining args to the chosen command or `main()`.
- Help handling:
  - `--help` with no command shows global usage (plus a command list when commands are registered).
  - `<command> --help` shows usage for that command, including its flags and the global flags.
- Dispatch rules:
  - If a recognized command is provided, its function is called with remaining positional args.
  - If no command is found but `main` exists, `main "$@"` runs.
  - Otherwise, an error is printed with a short usage summary.

## Parsing rules and environment export
- Long flags only (`--flag`); short `-f` style flags are not supported.
- The first non-flag token selects the command when any commands have been registered; subsequent tokens are treated as positional arguments.
- Flag defaults are set when you register them. Command-specific defaults are re-exported just before dispatch to ensure `CLI_ARG_*` is always available inside the command function.
- All exported variables share the prefix `CLI_ARG_` (configurable via `_CLI_ARG_PREFIX` inside `cli.sh` if you need to change it).

## More usage patterns
### Forwarding positional arguments to commands
```bash
add_cmd greet "Sends a greeting"
greet() {
    echo "Greeting: ${CLI_ARG_NAME}"
    for arg in "$@"; do
        echo "Arg: $arg"
    done
}
add_cmd_arg greet name "" "Name to greet"
cli_run "$@"
```

Call with extra args:
```bash
./script.sh greet --name="Jane Doe" extra1 extra2
```

### Global flags shared by all commands
```bash
add_arg verbose false "Enable verbose output"
add_cmd deploy "Ship the build"
deploy() {
    if [[ ${CLI_ARG_VERBOSE} == true ]]; then
        echo "Deploying verbosely"
    fi
    echo "Deploying to $1"
}
cli_run "$@"
```

### Colorized help output
All help screens are colorized by default. You can tweak the ANSI codes near the top of `cli.sh` if your environment requires different colors or if you prefer monochrome output.

## Example scripts in this repo
- `tests/scripts/main_no_args.sh`: Minimal `main()` with no flags.
- `tests/scripts/main_with_args.sh`: Demonstrates global flags exported to `CLI_ARG_*`.
- `tests/scripts/ping.sh`: Simple `ping` command.
- `tests/scripts/add_cmd_no_args.sh`: Command dispatch with positional args.
- `tests/scripts/add_cmd_with_args.sh`: Command-specific flags with defaults and overrides.

Run any of them directly to see how parsing behaves.

## Testing
Run the full suite (requires Bash):

```bash
./tests.sh
```

Each test prints colored output; failures exit non-zero.

## Design notes
- Uses only indexed arrays for portability to older Bash versions.
- Avoids associative arrays and external dependencies.
- Long flags only; short options and combined flags are intentionally unsupported to keep the parser minimal.

