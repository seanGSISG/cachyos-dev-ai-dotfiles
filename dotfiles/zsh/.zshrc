# === Custom Paths ===
# Add VSCode Insiders
export PATH="/home/lsdmt/vscode-insiders/bin:$PATH"

# === mise (Python, Node, etc. version manager) ===
eval "$(mise activate zsh)"

# === Core shell tools ===
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# === fzf bindings ===
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# === Zsh plugins (from pacman) ===
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# === Aliases ===
alias ls="eza --icons --group-directories-first --git"
alias ll="eza -l --icons --group-directories-first --git"
alias cat="bat"
alias rg="ripgrep"

# === History ===
setopt hist_ignore_all_dups share_history inc_append_history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# === Editor ===
export EDITOR="code-insiders --wait"
export VISUAL="$EDITOR"

# === direnv usage ===
# To use direnv, create a .envrc file in your project directory:
#
# For Python:
#   echo "layout python" > .envrc
#   direnv allow
#
# For Node:
#   echo "layout node" > .envrc
#   direnv allow
