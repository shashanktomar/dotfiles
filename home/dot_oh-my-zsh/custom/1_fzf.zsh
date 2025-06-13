###############################################################################
######################### FZF Options ########################################
###############################################################################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Dracula Theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Tell fzf to use rgrep
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

###############################################################################
######################### Reusable Functions ##################################
###############################################################################

# Default `fold` to screen width and break at spaces
function fold {
  if [ $# -eq 0 ]; then
    /usr/bin/fold -w $COLUMNS -s
  else
    /usr/bin/fold $*
  fi
}

# Use `fzf` against system dictionary
function spell {
  cat /usr/share/dict/words | fzf --preview 'wn {} -over | fold' --preview-window=up:60%
}


###############################################################################
################################# Utils #######################################
###############################################################################

# FZF preview
alias fzfp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --preview-window right:'60%' \
  --bind ctrl-u:preview-up,ctrl-d:preview-down"

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Lookup definition of word using `wn $1 -over`.
# If $1 is not provided, we'll use the `spell` command to pick a word.
#
# Requires:
#   brew install wordnet
#   brew install fzf
function dic {
  if [ $# -eq 0 ]; then
    wn `spell` -over | fold
  else
    wn $1 -over | fold
  fi
}

###############################################################################
################################### GIT #######################################
###############################################################################

# fco_preview - checkout git branch/tag, with a preview showing the commits between the tag/branch and HEAD
fco_preview() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# fgco - checkout git branch (including remote branches)
fgco() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

###############################################################################
################################### tmux ######################################
###############################################################################

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# tmi - attach to session with independent navigation
tmi() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    # Create grouped session for independent navigation
    local group_session="$1-$(date +%s)"
    tmux new-session -d -s "$group_session" -t "$1" 2>/dev/null && tmux $change -t "$group_session" || (tmux new-session -d -s $1 && tmux new-session -d -s "$group_session" -t "$1" && tmux $change -t "$group_session")
    return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && {
    local group_session="$session-$(date +%s)"
    tmux new-session -d -s "$group_session" -t "$session" && tmux $change -t "$group_session"
  } || echo "No sessions found."
}

# tmswapc - swap current window with target window 
tmswapc() {
  # Get current window index
  local current=$(tmux display-message -p '#I')
  # Generate list of windows with their indices and names
  # Format: "2: vim [layout] (active)"
  local selected=$(tmux list-windows -F "#{window_index}: #{window_name}" |
    grep -v "^${current}:" |
    fzf --height 40% \
      --reverse \
      --prompt="Swap current window with: ")

  # Exit if no selection made
  [[ -z "$selected" ]] && return 0
  # Extract the window index from selection
  local target_window="${selected%%:*}"
  # Perform the swap
  tmux swap-window -s "$current" -t "$target_window"
}

# tmswap - Prompt for both source and target windows and swap them 
tmswap() {
  # Define headers using heredoc
  read -r -d '' source_header <<'EOF'
=== TMUX WINDOW SWAP ===
Select the source window to swap from
EOF

  # Select source window
  local source_selected=$(tmux list-windows -F "#{window_index}: #{window_name}" |
    fzf --height 40% \
      --reverse \
      --header="${source_header}" \
      --header-first \
      --prompt="Source window > ")

  # Exit if no selection made
  [[ -z "$source_selected" ]] && return 0
  # Extract the source window index
  local source_window="${source_selected%%:*}"

  read -r -d '' target_header <<EOF
=== TMUX WINDOW SWAP ===
Swapping from '${source_selected}'
EOF

  # Select target window, excluding the source window
  local target_selected=$(tmux list-windows -F "#{window_index}: #{window_name}" |
    grep -v "^${source_window}:" |
    fzf --height 40% \
      --reverse \
      --header="${target_header}" \
      --header-first \
      --prompt="Target window > ")

  # Exit if no selection made
  [[ -z "$target_selected" ]] && return 0
  # Extract the target window index
  local target_window="${target_selected%%:*}"
  # Perform the swap
  tmux swap-window -s "$source_window" -t "$target_window"
}


###############################################################################
################################### node ######################################
###############################################################################

fnode() {
  if [ ! -f package.json ]; then
    echo "No package.json found in current directory"
    return 1
  fi
  
  if [ -f pnpm-lock.yaml ]; then
    manager="pnpm"
  elif [ -f yarn.lock ]; then
    manager="yarn"
  else
    echo "No yarn or pnpm lock file found. Defaulting to pnpm."
    manager="pnpm"
  fi

  local commands cmd
  commands=$(jq -r '.scripts | to_entries[] | "\(.key)\t\(.value)"' package.json) &&
  cmd=$(echo "$commands" | fzf --exit-0 --delimiter='\t' --with-nth=1 --preview='echo {2}') &&
  if [ -n "$cmd" ]; then
    selected=$(echo "$cmd" | cut -f1)
    full_command="$manager $selected"
    # This adds it to history works in both zsh and bash
    print -s "$full_command"
    eval "$full_command"
  fi
}

###############################################################################
################################ aerospace ####################################
###############################################################################

# select aerospace workspace
faw() {
  local workspace
  workspace=$(aerospace list-workspaces --all | fzf --exit-0)

  # Exit if no selection made
  [[ -z "$workspace" ]] && return 0
  aerospace workspace "$workspace"
}


# organise windows
_fao() {
  # Define headers using heredoc
  read -r -d '' source_header <<'EOF'
=== AEROSPACE WINDOW ASSIGNMENT ===
Select the window
EOF

  # Select window
  local selection
  selection=$(aerospace list-windows --workspace 1 --json |
    jq -r '.[] | "\(.["window-id"])\t\(.["app-name"]): \(.["window-title"])"' |
    fzf --height 40% \
      --reverse \
      --header="${source_header}" \
      --header-first \
      --prompt="Window > " \
      --with-nth 2..)

  # Exit if no selection made
  [[ -z "$selection" ]] && return 1

  local window_id window_name
  window_id=$(echo "$selection" | cut -f1)
  window_name=$(echo "$selection" | cut -f2)

  read -r -d '' target_header <<EOF
=== AEROSPACE WINDOW ASSIGNMENT ===
Moving window '${window_name}'
EOF

  local workspace
  workspace=$(aerospace list-workspaces --all |
    fzf --height 40% \
      --reverse \
      --header="${target_header}" \
      --header-first \
      --prompt="Target workspace > ")

  # Exit if no selection made
  [[ -z "$workspace" ]] && return 1
  aerospace move-node-to-workspace --window-id "${window_id}" "${workspace}"
}

# organise windows
fao() {
  while true; do
    # Check if there are any windows in workspace 1
    if [[ $(aerospace list-windows --workspace 1 --json | jq length 2>/dev/null) -eq 0 ]]; then
      echo "No windows left to assign"
      return 0
    fi

    # Run fao and capture its exit status
    _fao
    local exit_code=$?

    # Break if fao exited non-zero (including from Ctrl-C)
    if [[ $exit_code -ne 0 ]]; then
      return $exit_code
    fi
  done
}

###############################################################################
################################## docker #####################################
###############################################################################

# tail docker container logs
fdlt() {
  local selection container_id container_name

  selection=$(docker ps --format '{{.ID}}\t{{.Names}}' |
    fzf --height 40% --reverse --prompt="Select container: ")

  # Exit if no selection is made
  [[ -z "$selection" ]] && return 0

  container_id=$(echo "$selection" | cut -f1)
  container_name=$(echo "$selection" | cut -f2)

  echo "Tailing logs for container: $container_name ($container_id)"
  docker logs -f --tail 20 "$container_id"
}
