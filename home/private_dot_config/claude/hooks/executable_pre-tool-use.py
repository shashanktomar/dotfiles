#!/usr/bin/env uv run
# /// script
# dependencies = []
# requires-python = ">=3.9"
# ///

import json
import sys
import re
from typing import Optional, List, Tuple

# Commands that should be delegated to better alternatives
COMMAND_DELEGATIONS: List[Tuple[str, str]] = [
    (r"\bfind\s+", "Use 'fd' instead of 'find' for faster and better search results"),
    (r"(&&|;|\|).*?\bgrep\b|\bgrep\b.*?(\||&&|;)|\bgrep\s+", "Use 'rg' (ripgrep) instead of grep for faster and better search results"),
]

# Commands that should be blocked entirely (for future use)
BLOCKED_COMMANDS: List[Tuple[str, str]] = [
    # (r"\brm\s+-rf\s+/", "Dangerous command: removing from root directory"),
]

def check_command_delegation(command: str) -> Optional[str]:
    """Check if command should be delegated to a better alternative."""
    for pattern, suggestion in COMMAND_DELEGATIONS:
        if re.search(pattern, command):
            return suggestion
    return None

def check_command_blocked(command: str) -> Optional[str]:
    """Check if command should be blocked entirely."""
    for pattern, reason in BLOCKED_COMMANDS:
        if re.search(pattern, command):
            return reason
    return None

def process_bash_command(command: str) -> Optional[dict]:
    """Process bash command and return decision if action needed."""
    # First check if command is blocked
    block_reason = check_command_blocked(command)
    if block_reason:
        return {
            "decision": "block",
            "reason": block_reason
        }
    
    # Then check if command should be delegated
    delegation_suggestion = check_command_delegation(command)
    if delegation_suggestion:
        return {
            "decision": "block",
            "reason": delegation_suggestion
        }
    
    return None

def main():
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    
    command = data.get("tool_input", {}).get("command", "")
    
    decision = process_bash_command(command)
    if decision:
        print(json.dumps(decision))
    
    sys.exit(0)

if __name__ == "__main__":
    main()