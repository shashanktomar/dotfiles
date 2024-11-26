# Chezmoi Templates

## Syntax

- Template actions are written inside double curly brackets, {{ and }}. Text outside actions is copied literally.
- Actions can be variables, pipelines, or control statements.
- Check golang template [doc](https://pkg.go.dev/text/template) for more details.
- Chezmoi extend template functions by using [sprig](http://masterminds.github.io/sprig/) library
- It also support its own template functions documented [here](https://www.chezmoi.io/reference/templates/functions/)

## Working with templates

You can create a template file in one of the following ways:

- create a file ending in `.tmpl`
- create in under `chezmoitemplates` directory or a subdirectory
- while adding a file, do `chezmoi add --template ~/.zshrc`. This will create `dot_zshrc.tmpl`
- if a file is already managed by chezmoi, but is not a template, you can make it a template by running `chezmoi chattr +template ~/.zshrc`

Using `.chezmoitemplates`

- Files in the `.chezmoitemplates` subdirectory are parsed as templates and are available to be included in other templates using the template action with a name equal to their relative path to the `.chezmoitemplates` directory.
- Different ways of passing data
  - By default, such templates will be executed with nil data. If you want to access template variables (e.g. `.chezmoi.os`) in the template you must pass the data explicitly like `{{ template "template_file" . }}`
  - See [this](https://www.chezmoi.io/user-guide/templating/#passing-multiple-arguments) for different ways of passing data

Available variables

- To see all the available variables in template, use `chezmoi data`

Testing templates:

- `chezmoi execute-template '{{ .chezmoi.hostname }}'` or `chezmoi execute-template < dot_zshrc.tmpl` or `cat foo.txt | chezmoi execute-template`

## Patterns

- for simple changes between files on different machines, use variables
- to ignore files or directories on specific machines, use `.chezmoiignore` with template conditionals. See example [here](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/#ignore-files-or-a-directory-on-different-machines)
- to have different location for the same files on different machines, use `.chezmoitemplates` as described [here](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/#handle-different-file-locations-on-different-systems-with-the-same-contents)
- to use completely different dotfiles on different machines, follow [this](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/#use-completely-different-dotfiles-on-different-machines) pattern
