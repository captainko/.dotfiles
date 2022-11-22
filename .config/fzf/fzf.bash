# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cko/.local/src/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/cko/.local/src/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cko/.local/src/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/cko/.local/src/fzf/shell/key-bindings.bash"
