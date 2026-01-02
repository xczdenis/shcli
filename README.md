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

main() {
    echo "Hello, ${CLI_ARG_NAME}!"
}

add_arg name "world" "Who to greet"

cli_run "$@"
```

Run it:

```bash
./hello.sh --name=Sam
```

## Example scripts
The `tests/scripts/` directory contains small examples:
- `main_no_args.sh`: demonstrates a simple `main()`.
- `main_with_args.sh`: shows global flags being exported to `CLI_ARG_*` variables.
- `ping.sh`: registers a `ping` command.

## Testing
Run the full suite (requires Bash):

```bash
./tests.sh
```

Each test prints colored output; failures exit non-zero.

## Development notes
- The library avoids Bash-only features like associative arrays to maximize portability.
- Colors are defined at the top of `cli.sh` and can be tweaked as needed.
