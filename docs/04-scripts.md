# Chezmoi Scripts and Hooks

## Scripts

Scripts are prefixed with `run_` and are executed in **alphabetical order** when you run `chezmoi apply`.

### Execution frequency:

- executed always: `run_`
- executed on change: `run_onchange_`. These scripts are only executed if their content has changed since the last time they were run. These scripts are executed whenever their contents change, even if a script with the same contents has run before.
  - To run a script when the contents of another file changes, add the checksum of other file in the script. See example [here](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes)
- executed once: `run_once_`. Only executed if a script with the same contents has not been run before, i.e. if the script is new or if its contents have changed.
  - chezmoi tracks the content's SHA256 hash and stores it in a database. If the content has been run before (even under a different filename), the script will not run again unless the content itself changes
- to reset the execution state of `run_onchange_`, execute `chezmoi state delete-bucket --bucket=entryState`.
- to reset the execution state of `run_once_`, execute `chezmoi state delete-bucket --bucket=scriptState`.

### Order of execution:

- scripts are run in alphabetical order
- scripts are normally run while chezmoi updates your dotfiles. For example, `run_b.sh` will be run after updating `a.txt` and before updating `c.txt`.
- to run scripts before or after the updates, use the `before_` or `after_` attributes, respectively.
  - Scripts with the `before_` attribute are executed before any files, directories, or symlinks are updated.
  - Scripts with the `after_` attribute are executed after all files, directories, and symlinks have been updated.

### Path and Env Vars

- chezmoi sets a number of `CHEZMOI*` environment variables when running scripts, corresponding to commonly-used template data variables. Extra environment variables can be set in the `env` or `scriptEnv` configuration variables.
- Scripts will normally run with their working directory set to their equivalent location in the destination directory.
  - Example: A script in `~/.local/share/chezmoi/dir/run_script` will be run with a working directory of `~/dir`.
  - If the equivalent location in the destination directory either does not exist or is not a directory, then chezmoi will walk up the script's directory hierarchy and run the script in the first directory that exists and is a directory.

### Things to Note:

- Scripts break chezmoi's declarative approach and should be used sparingly.
- All scripts should be idempotent, including `run_onchange_` and `run_once_` scripts.
- Scripts with the `.tmpl` suffix are treated as templates, with the usual template variables available. If the template resolves to only whitespace or an empty string, the script will not be executed, which is useful for disabling scripts dynamically.
- In verbose mode, the scripts' contents are printed before execution.
- In dry-run mode, scripts are not executed.

### How are scripts executed?

When executing a script, chezmoi generates the script contents in a file in a temporary directory with the executable bit set and then executes it using `exec(3)`. As a result, the script must either include a `#!` line or be an executable binary. Script working directory is set to the first existing parent directory in the destination tree.

If a `.chezmoiscripts` directory exists at the root of the source directory, scripts in this directory are executed as normal scripts, without creating a corresponding directory in the target state.

## Hooks

Hook commands are executed before and after events.

- Unlike scripts, hooks are always run, even if `--dry-run` is specified.
- Hooks should be fast and idempotent.

There are two type of events:

- a command run like `chezmoi add`
- `read-source-state`

Each event has a `.pre` and a `.post` command. See [docs](https://www.chezmoi.io/reference/configuration-file/hooks/) for examples.
