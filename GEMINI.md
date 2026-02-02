# Gemini Context

This file provides context for the Gemini AI agent.

For general project information, including overview, installation, usage, features, and testing, please refer to the [README.md](README.md) file.

## Development Conventions

### Code Style

The project uses the following code style, as defined in `.editorconfig`:

*   **Charset**: `utf-8`
*   **Indentation**: 4 spaces
*   **Final Newline**: A new line at the end of files is enforced.
*   **Trailing Whitespace**: Trailing whitespace is trimmed from files.

### Shell Scripting

*   All scripts are written in `bash`.
*   Scripts should be written to be robust and handle errors gracefully (`set -e` is used in the main scripts).

### Version Control

*   The `.gitignore` file excludes the `pruebas/` and `tmp/` directories from version control.