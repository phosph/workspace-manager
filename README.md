# Workspace Manager

A bash-based utility for managing development workspaces.

## Project Overview

This project provides a set of shell commands to create, navigate, and organize different development environments efficiently.

A "workspace root" is a directory that contains multiple "workspaces". The location of the workspace root is defined by the `WORKSPACE_ROOT` environment variable, which is used by all commands except for `new-root`. Each workspace is a directory that can be further divided into "zones" (e.g., `core`, `doc`).

The main script is `workspace.sh`, which is designed to be aliased or sourced in your shell environment for easy access.

## Features

*   **Workspace Management:** Create, list, and navigate between different development workspaces.
*   **Zone Support:** Organize your workspaces into logical zones like `core` or `doc`.
*   **Customizable Shell Integration:** Designed to integrate seamlessly with your bash environment.
*   **Command Autocompletion:** Supports autocompletion for subcommands and workspace names.
*   **Isolated Testing:** Includes a test suite that can be run in a clean, containerized environment.

## Installation and Usage

### Installation

To install the workspace manager, run the `install.sh` script:

```bash
./install.sh
```

This will create a configuration directory at `~/.wrk-config` and modify your `~/.bashrc` to source the necessary environment variables and functions. You will need to open a new terminal session or source your `.bashrc` for the changes to take effect.

### Usage

The primary command is `workspace`. Here are some of the key subcommands:

*   `workspace new-root`: Interactively creates a new workspace root.
*   `workspace create <WORKSPACE_NAME>`: Creates a new workspace in the current workspace root.
*   `workspace list`: Lists all available workspaces in the current root.
*   `workspace go <WORKSPACE_NAME>`: Navigates to the specified workspace.
*   `workspace go <WORKSPACE_NAME> --zone <ZONE>`: Navigates to a specific zone within a workspace.
*   `workspace path <WORKSPACE_NAME>`: Prints the absolute path of a workspace.
*   `workspace path --current`: Prints the path of the current workspace.

### Autocompletion

The `install.sh` script also sets up command-line autocompletion for the `workspace` command (and any aliases you create). This includes suggestions for subcommands and available workspaces.

## Testing

The project includes a comprehensive test suite to ensure functionality and reliability.

### Local Tests

You can run the tests directly on your local machine:

```bash
./run_tests.sh
```

### Containerized Tests (Recommended)

For a more isolated and consistent testing environment, you can run the tests inside a container using Podman or Docker. This requires either `podman` or `docker` to be installed on your system.

```bash
./run_tests_container.sh
```
