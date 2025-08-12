#!/bin/bash

input=$(cat)

current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
session_id=$(echo "$input" | jq -r '.session_id')

os_icon=""

current_basename=$(basename "$current_dir")
project_basename=$(basename "$project_dir")

if [[ "$current_dir" == "$project_dir" ]]; then
    dir_display="$project_basename"
else
    if [[ "$current_dir" == "$project_dir"/* ]]; then
        relative_path=${current_dir#$project_dir/}
        dir_display="$project_basename/$relative_path"
    else
        dir_display="$current_basename"
    fi
fi

cd "$current_dir" 2>/dev/null || cd "$HOME"

# Git branch and file status
git_branch=$(git branch --show-current 2>/dev/null)
git_file_counts=""

if [[ -n "$git_branch" ]]; then
    # Get git status
    git_status=$(git status --porcelain 2>/dev/null)
    
    if [[ -n "$git_status" ]]; then
        # Count different types of changes
        modified_count=$(echo "$git_status" | rg -c "^ M|^M " || echo "0")
        added_count=$(echo "$git_status" | rg -c "^\?\?|^A |^ A" || echo "0")
        deleted_count=$(echo "$git_status" | rg -c "^ D|^D " || echo "0")
        
        # Build file count string
        counts=""
        [[ $modified_count -gt 0 ]] && counts="${counts}±${modified_count} "
        [[ $added_count -gt 0 ]] && counts="${counts}+${added_count} "
        [[ $deleted_count -gt 0 ]] && counts="${counts}-${deleted_count} "
        
        # Trim trailing space and add brackets if there are any counts
        if [[ -n "$counts" ]]; then
            counts="${counts% }"  # Remove trailing space
            git_file_counts=" [${counts}]"
        fi
    fi
fi

# Build the status line
printf "\033[36m%s\033[0m \033[34m%s\033[0m" "$os_icon $model_name" "$dir_display"

if [[ -n "$git_branch" ]]; then
    printf " ⎇ \033[32m%s\033[0m\033[33m%s\033[0m" "$git_branch" "$git_file_counts"
fi