# shcli

A minimal Bash helper for building small, colorful command-line tools without dependencies. It keeps state in simple arrays and exports parsed arguments as environment variables for easy access inside your scripts.

## Features
- **Commands and flags**: register commands plus global or command-specific flags with defaults and help text.
- **Environment export**: each flag is exported as `CLI_ARG_<UPPERCASE_NAME>` so your functions can read values directly.
- **Help output**: auto-generated usage with colorized sections for commands and flags.
- **Batteries included tests**: tiny test suite exercising the library and usage examples.

## Getting started
1. Source the library in your script.
2. Register commands and flags.
3. Implement command functions or a fallback `main()`.
4. Call `cli_run "$@"` at the end of the file.

```bash
#!/usr/bin/env bash

source ./cli.sh

add_arg name "world" "Who to greet"
add_cmd ping "Check connectivity"
add_cmd_arg ping count 3 "Number of ping attempts"

main() {
    echo "Hello, ${CLI_ARG_NAME}!"
}

ping() {
    # Displays current flag values as exported env vars
    echo "Pinging ${CLI_ARG_NAME} ${CLI_ARG_COUNT} times..."
}

cli_run "$@"
```

Run it:

```bash
./hello.sh --name=Sam
```

Built-in help is available immediately via `-h` or `--help`:

```bash
# General help with commands and global flags
./hello.sh --help

# Command-specific help (also works with -h)
./hello.sh ping --help
```

Example outputs (color stripped here):

```
Usage: hello.sh <command> [--flag=value] [--help]

For more information, try '--help'.

Commands:
  ping   Check connectivity

Global flags:
  --name  Who to greet (default: 'world')

Usage: hello.sh ping [--flag=value] [args]

ping - Check connectivity

Flags:
  --count  Number of ping attempts (default: '3')

Global flags:
  --name  Who to greet (default: 'world')
```

## Example scripts
The `tests/scripts/` directory contains small examples:
- `main_no_args.sh`: demonstrates a simple `main()`.
- `main_with_args.sh`: shows global flags being exported to `CLI_ARG_*` variables.
- `ping.sh`: registers a `ping` command.

## API quick reference
- `add_arg name default help`: registers a global flag and exports it as `CLI_ARG_<NAME>`.
- `add_cmd name help`: registers a command name and description.
- `add_cmd_arg cmd flag default help`: registers a flag specific to a command and exports it as `CLI_ARG_<FLAG>` when that command runs.

Global help is printed with `-h` or `--help`, and command-specific help with `[command] -h` or `[command] --help`.

## Testing
Run the full suite (requires Bash):

```bash
./tests.sh
```

Each test prints colored output; failures exit non-zero.

## Development notes
- The library avoids Bash-only features like associative arrays to maximize portability.
- Colors are defined at the top of `cli.sh` and can be tweaked as needed.
