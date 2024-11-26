# Chezmoi Basics

Chezmoi syncs data from a **source** directory to a **target** directory. It can be controlled using a config file. It also supports scripts and templates.
Things are executed in order. Given a file `dot_a`, a script `run_z`, and a directory `exact_dot_c`, chezmoi will first create `.a`, create `.c`, and then execute `run_z`.

## Three primary directories

- source directory
  - the default is `~/.local/share/chezmoi`, in our case it is `~/.dotfiles`
  - this is what you commit
  - `chezmoi source-path`
- target directory
  - this defaults to users home directory
  - this is what source directory syncs to
  - `chezmoi target-path`
- `~/.config/chezmoi` directory
  - has the config file which is specific to the machine
  - this is generated when you run `chezmoi init` on a new machine
  - it can be generated from the template `.chezmoi.toml.tmpl` file in the **source directory** by running `chezmoi init -S <path-to-cloned-dir>`

## File prefixes and suffixes

They are also called source state attributes because they influence the state of the files. Details can be found [here](https://www.chezmoi.io/reference/source-state-attributes/)

### Target Types

#### Files

Files are represented by regular files in the source state.

- The `encrypted_` attribute determines whether the file in the source state is encrypted.
- The `executable_` attribute will set the executable bits in the target state
- The `private_` attribute will clear all group and world permissions.
- The `readonly_` attribute will clear all write permission bits in the target state.
- Files with the `.tmpl` suffix will be interpreted as templates. If the target contents are empty then the file will be removed, unless it has an `empty_` prefix.
- Files with the `create_` prefix will be created in the target state with the contents of the file in the source state if they do not already exist. If the file in the destination state already exists then its contents will be left unchanged.
- Files with the `modify_` prefix are treated as scripts that modify an existing file.
  - If the file contains a line with the text `chezmoi:modify-template` then that line is removed and the rest of the script is executed template with the existing file's contents passed as a string in `.chezmoi.stdin`. The result of executing the template are the new contents of the file.
  - Otherwise, the contents of the existing file (which maybe empty if the existing file does not exist or is empty) are passed to the script's standard input, and the new contents are read from the script's standard output.
- Files with the `remove_` prefix will cause the corresponding entry (file, directory, or symlink) to be removed in the target state.

#### Directories

Directories are represented by regular directories in the source state.

- The `exact_` attribute causes chezmoi to remove any entries in the target state that are not explicitly specified in the source state
- The `private_` attribute causes chezmoi to clear all group and world permissions
- The `readonly_` attribute will clear all write permission bits

#### Symbolic links

Symbolic links are represented by regular files in the source state with the prefix `symlink_`. The contents of the file will have a trailing newline stripped, and the result be interpreted as the target of the symbolic link.

- Symbolic links with the `.tmpl` suffix in the source state are interpreted as templates.
- If the target of the symbolic link is empty or consists only of whitespace, then the target is removed.

#### Scripts

Check [scripts](./04-scripts.md) document for details.

## Application Order

chezmoi is deterministic in its order of application. The order is:

- Read the source state.
- Read the destination state.
- Compute the target state.
- Run `run_before_` scripts in alphabetical order.
- Update entries in the target state (files, directories, externals, scripts, symlinks, etc.) in alphabetical order of their target name. Directories (including those created by externals) are updated before the files they contain.
- Run `run_after_` scripts in alphabetical order.

Target names are considered after all attributes are stripped. Example: Given `create_alpha` and `modify_dot_beta` in the source state, `.beta` will be updated before `alpha` because `.beta` sorts before `alpha`.

chezmoi assumes that the source or destination states are not modified while chezmoi is being executed. This assumption permits significant performance improvements, including allowing chezmoi to only read files from the source and destination states if they are needed to compute the target state. chezmoi's behavior when the above assumptions are violated is undefined. For example, using a `run_before_` script to update files in the source or destination states violates the assumption that the source and destination states do not change while chezmoi is running.
