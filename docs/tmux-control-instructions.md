# tmux-control Instructions

A command-line tool for controlling CLI applications running in tmux panes/windows.
Automatically detects whether you're inside or outside tmux and uses the appropriate mode.

## Auto-Detection

- **Inside tmux (Local Mode)**: Manages panes in your current tmux window
- **Outside tmux (Remote Mode)**: Creates and manages a separate tmux session with windows

## Prerequisites

- tmux must be installed
- The `tmux-control` command must be available (installed via uv)

## ⚠️ IMPORTANT: Always Launch a Shell First!

**Always launch zsh first** to prevent losing output when commands fail:

```shell
tmux-control --create-pane "session:window.pane" # Create pane first
tmux-control --send %48 "zsh" # Launch shell FIRST
tmux-control --send %48 "your-command" # Then run commands
```

If you launch a command directly and it errors, the pane closes immediately and you lose all output!

## Core Commands

### List sessions and panes

```shell
tmux-control --sessions                    # List all tmux sessions
tmux-control --panes                       # List all panes across sessions
tmux-control --panes --session dotfiles   # List panes for specific session
```

### Create a new pane

```shell
tmux-control --create-pane "session:window.pane"
# Example: tmux-control --create-pane "dotfiles:1.1"
# Returns: pane ID (e.g., %48)
```

### Send input to a pane

```shell
tmux-control --send PANE_ID "text"
# Example: tmux-control --send %48 "print('hello')"

# By default, sends Enter after the text.
# This ensures compatibility with various CLI applications.
```

### Capture output from a pane

```shell
tmux-control --capture PANE_ID
# Example: tmux-control --capture %48
```

### Interactive mode

```shell
tmux-control --interactive
# Opens an interactive session for managing tmux
```

### Other useful commands

```shell
# Kill a specific pane
tmux-control --kill-pane PANE_ID

# Kill an entire session
tmux-control --kill-session SESSION_NAME

# Send interrupt (Ctrl+C)
# Use tmux send-keys directly: tmux send-keys -t %48 C-c
```

## Recommended Workflow

1. **Create a pane**: Use `--create-pane` to get a new workspace
2. **Launch shell**: Always send `zsh` or `bash` first
3. **Run your commands**: Send commands one by one
4. **Capture output**: Use `--capture` to see results
5. **Clean up**: Kill panes when done

## Example Session

```shell
# Step 1: Create a new pane
PANE_ID=$(tmux-control --create-pane "dotfiles:1.1")

# Step 2: Launch shell first (IMPORTANT!)
tmux-control --send $PANE_ID "zsh"

# Step 3: Run your commands
tmux-control --send $PANE_ID "python3"
tmux-control --send $PANE_ID "print('Hello from tmux!')"
tmux-control --send $PANE_ID "exit()"

# Step 4: Capture output
tmux-control --capture $PANE_ID

# Step 5: Clean up
tmux-control --kill-pane $PANE_ID
```

## Tips and Best Practices

- **Save pane IDs**: Store them in variables for repeated use
- **Use interactive mode**: For complex workflows with multiple steps
- **Test incrementally**: Capture output frequently to verify results
- **Handle errors gracefully**: Always launch a shell first to avoid losing output
- **Clean up**: Remember to kill panes when done to avoid clutter

## Troubleshooting

- **Pane not found**: Check that the pane ID is correct with `--panes`
- **Command not executing**: Ensure you launched a shell first
- **Output missing**: The command may have failed - always use a shell
- **Permission denied**: Check that tmux is properly installed and accessible

## Integration with Claude Code

This tool is particularly useful for:
- Testing CLI applications
- Running interactive Python sessions
- Managing multiple development environments
- Automating repetitive terminal tasks
- Debugging CLI workflows

Remember: The key to success is **always launching a shell first**!