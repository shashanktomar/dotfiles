#!/bin/bash
# Read JSON input once
input=$(cat)

# Helper functions for common extractions
get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version // ""' 2>/dev/null || true; }
get_unknown_fields() {
    local fields=$(echo "$input" | jq -r 'keys[]' 2>/dev/null || true)
    local unknown=""
    for field in $fields; do
        case "$field" in
            model|workspace|session_id|cwd|transcript_path|version) ;;
            *) [[ -n "$field" ]] && unknown="$unknown,$field" ;;
        esac
    done
    local result=$(echo "$unknown" | sed 's/^,//')
    [[ -n "$result" ]] && echo "$result" || echo ""
}

# Use the helpers
MODEL=$(get_model_name)
CURRENT_DIR=$(get_current_dir)
PROJECT_DIR=$(get_project_dir)
VERSION=$(get_version)
UNKNOWN_FIELDS=$(get_unknown_fields)

# Get directory display name
project_base=$(basename "$PROJECT_DIR")
if [[ "$CURRENT_DIR" == "$PROJECT_DIR" ]]; then
    DIR_DISPLAY="$project_base"
else
    current_base=$(basename "$CURRENT_DIR")
    DIR_DISPLAY="$project_base/…/$current_base"
fi

# Get git info
cd "$CURRENT_DIR" 2>/dev/null || cd "$HOME"
GIT_BRANCH=$(git branch --show-current 2>/dev/null)

# Get git file counts
if [[ -n "$GIT_BRANCH" ]]; then
    git_status=$(git status --porcelain 2>/dev/null)
    if [[ -n "$git_status" ]]; then
        modified=$(echo "$git_status" | rg -c "^ M|^M " || echo "0")
        added=$(echo "$git_status" | rg -c "^\?\?|^A |^ A" || echo "0")
        counts=""
        [[ $modified -gt 0 ]] && counts="±$modified"
        [[ $added -gt 0 ]] && counts="$counts +$added"
        [[ -n "$counts" ]] && FILE_COUNTS=" [$counts]"
    fi
fi

# Output status line 1
printf "\033[34m%s\033[0m" "$DIR_DISPLAY"
[[ -n "$GIT_BRANCH" ]] && printf " ⎇ \033[32m%s\033[0m\033[33m%s\033[0m" "$GIT_BRANCH" "$FILE_COUNTS"

# Output status line 2
printf "\n\033[36m%s\033[0m" "$MODEL"
[[ -n "$VERSION" ]] && printf " \033[90m%s\033[0m" "$VERSION"
# [[ -n "${UNKNOWN_FIELDS:-}" ]] && printf " \033[91m(%s)\033[0m" "$UNKNOWN_FIELDS"
# echo "DEBUG: UNKNOWN_FIELDS='$UNKNOWN_FIELDS'" >> /tmp/statusline-debug.log
