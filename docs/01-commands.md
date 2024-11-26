# Chezmoi Cheatsheet

Exhaustive list can be found [here](https://www.chezmoi.io/reference/commands/). Supported command line flags can be found [here](https://www.chezmoi.io/reference/command-line-flags/)

Housekeeping:

- `chezmoi init`
- `chezmoi doctor`
- `chezmoi import`
- `chezmoi upgrade`

Making changes:

- `chezmoi cd`
- `chezmoi add` to add a file from target directory to the source directory. Also check `re-add`
- `chezmoi forget`: stop managing a file. Remove it from source directory
- `chezmoi edit`: open a source file to edit
- `chezmoi edit-config` and `chezmoi edit-config-template`
- `chezmoi generate`: Generates output for use with chezmoi. The currently supported outputs are:
  - `git-commit-message` and `install.sh`
  - Example: `chezmoi git commit -m "$(chezmoi generate git-commit-message)"`
- other useful commands: `chattr, encrypt, decrypt, secret, git, merge, merge-all`

Applying Changes:

- `-vn`: v is for verbose and the `-n` (dry run) flag is to not make any actual changes. The combination -n -v is very useful if you want to see exactly what changes would be made.
- `chezmoi diff` to see the changes that will be made
  - pull and diff in same command: `chezmoi git pull -- --autostash --rebase && chezmoi diff`
- `chezmoi status` gives a quick summary of what files would change if you ran `chezmoi apply`
- apply commands
  - `chezmoi -v apply` or `chezmoi -nv apply` for verbose and dry-run
  - `chezmoi update` to pull and apply with one command
    - this runs `git pull --autostash --rebase` and then `chezmoi apply`
- `chezmoi execute-template`: Execute templates. This is useful for testing templates or for calling chezmoi from other scripts.

Inspect:

- `chezmoi cat-config`: print the chezmoi config
- `chezmoi dump-config`: print the full information about chezmoi config
- `chezmoi cat`: print file content to stdout after resolving templates
- `chezmoi state`
- `chezmoi data`: Write the computed template data to stdout.
- `chezmoi dump <target>`: print the information about target file
- `chezmoi managed` or `chezmoi list`
- `chezmoi unmanaged`
- `chezmoi ignored`
- `chezmoi source-path` and `chezmoi target-path`
- `chezmoi verify`

Dangerous Commands:

- `destroy, purge`
