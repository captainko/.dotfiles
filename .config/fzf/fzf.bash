# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cko/drives/dev/contributes/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/cko/drives/dev/contributes/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cko/drives/dev/contributes/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/cko/drives/dev/contributes/fzf/shell/key-bindings.bash"
