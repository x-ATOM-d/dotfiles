# --- Powerlevel10k Instant Prompt (zostaw blisko początku) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Ścieżki ---
export PATH=/run/current-system/sw/bin:$PATH
export NIX_PATH=/nix/var/nix/profiles/per-user/$(whoami)/nixpkgs:nixpkgs=channel:nixos-unstable

# --- Powerlevel10k Theme ---
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Wtyczki Zsh ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Historia ---
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- Strzałki w historii ---
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# --- Alias ls (Eza) ---
alias ls="eza --icons=always"

# --- Zoxide (lepsze cd) ---
eval "$(zoxide init zsh)"
alias cd="z"

# --- Aliasy użytkownika ---
alias c="clear"
alias e="exit"
alias y="yazi"
alias n="nvim"
alias t="tmux"
alias tn="tmux new -s"
alias ga="git add ."
alias gs="git status -s"
alias gc="git commit -m"

# --- Yazi z powrotem do katalogu ---
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# --- Edytor ---
export EDITOR=nvim
