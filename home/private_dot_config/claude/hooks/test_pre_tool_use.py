#!/usr/bin/env uv run
# /// script
# dependencies = [
#   "pytest>=7.0",
#   "pytest-cov",
# ]
# requires-python = ">=3.9"
# ///

import json
import subprocess
import sys
from pathlib import Path
import pytest

SCRIPT_PATH = Path(__file__).parent / "executable_pre-tool-use.py"


class TestPreToolUseHook:
    """Test cases for the pre-tool-use hook."""

    def run_hook(self, input_data: dict) -> tuple[int, str, str]:
        """Run the hook script with given input and return exit code, stdout, stderr."""
        process = subprocess.run(
            [sys.executable, str(SCRIPT_PATH)],
            input=json.dumps(input_data),
            text=True,
            capture_output=True,
        )
        return process.returncode, process.stdout, process.stderr

    def test_find_command_blocked(self):
        """Test that find commands are blocked with proper suggestion."""
        input_data = {
            "tool_name": "Bash",
            "tool_input": {"command": "find . -name '*.py'"},
        }

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        output = json.loads(stdout)
        assert output["decision"] == "block"
        assert "fd" in output["reason"]
        assert "find" in output["reason"]

    def test_normal_command_allowed(self):
        """Test that normal commands are allowed."""
        input_data = {"tool_name": "Bash", "tool_input": {"command": "ls -la"}}

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        assert stdout == ""  # No output means approved

    def test_find_in_middle_of_command(self):
        """Test that find is detected even in the middle of a command."""
        input_data = {
            "tool_name": "Bash",
            "tool_input": {"command": "echo 'searching' && find /tmp -type f"},
        }

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        output = json.loads(stdout)
        assert output["decision"] == "block"

    def test_find_as_part_of_word_not_blocked(self):
        """Test that 'find' as part of another word is not blocked."""
        input_data = {
            "tool_name": "Bash",
            "tool_input": {"command": "echo 'finding files with finder'"},
        }

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        assert stdout == ""  # Should be approved

    def test_invalid_json_input(self):
        """Test handling of invalid JSON input."""
        process = subprocess.run(
            [sys.executable, str(SCRIPT_PATH)],
            input="invalid json",
            text=True,
            capture_output=True,
        )

        assert process.returncode == 1
        assert "Invalid JSON input" in process.stderr

    def test_missing_command_field(self):
        """Test handling when command field is missing."""
        input_data = {"tool_name": "Bash", "tool_input": {}}

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        assert stdout == ""  # Should handle gracefully

    @pytest.mark.parametrize(
        "command,should_block",
        [
            ("find . -name test", True),
            ("find /home -type d", True),
            ("ls | grep test", True),  # Now blocks grep in pipelines
            ("cd .. && pwd && ls -la | grep just", True),  # Blocks grep in command chains
            ("grep pattern file.txt", True),  # Blocks standalone grep
            ("echo hello && grep test", True),  # Blocks grep after &&
            ("grep test; ls", True),  # Blocks grep before ;
            ("fd --type f", False),
            ("echo find", False),  # Won't block - no space after find
            ("# find command", True),  # This will block
            ("ls -la", False),  # Normal commands allowed
            ("rg pattern", False),  # ripgrep allowed
        ],
    )
    def test_various_commands(self, command, should_block):
        """Test various command patterns."""
        input_data = {"tool_name": "Bash", "tool_input": {"command": command}}

        exit_code, stdout, stderr = self.run_hook(input_data)

        assert exit_code == 0
        if should_block:
            output = json.loads(stdout)
            assert output["decision"] == "block"
        else:
            assert stdout == ""


if __name__ == "__main__":
    pytest.main(
        [__file__, "-v", "--cov=executable_pre-tool-use", "--cov-report=term-missing"]
    )

