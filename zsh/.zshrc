# --- Powerlevel10k Instant Prompt (zostaw blisko początku) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- FZF ---
fcd() {
  local dir
  dir=$(find "${1:-.}" -type d -not -path '*/.*/*' 2>/dev/null | fzf) && cd "$dir"
}


# --- Ścieżki ---
export PATH=/run/current-system/sw/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

export LANG=pl_PL.UTF-8
export LC_ALL=pl_PL.UTF-8


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
alias ta="tmux attach -t"
alias ga="git add ."
alias gs="git status -s"
alias gc="git commit -m"

# --- Open buffer line in editor ---
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# --- Images ---
alias ic="ascii-image-converter -C -c"

# --- Twitch Player ---
alias ewroon="open -a Vivaldi --args --app='https://player.twitch.tv/?channel=ewroon&parent=twitch.tv'"
alias angela35="open -a Vivaldi --args --app='https://player.twitch.tv/?channel=angela35&parent=twitch.tv'"

# ---- VPN ---
alias vpnwarsaw="~/Developer/Scripts/vpn-warsaw-rotate.sh" # reczny restart
alias vpnwarsaw-down="sudo wg-quick down pl-waw" # wylacz vpn
alias vpnwarsaw-up="sudo wg-quick up pl-waw" # reczne wlaczenie vpn
alias vpnip="curl -s ifconfig.me | tee ~/vpn-warsaw.log" # aktualne ip
alias vpnlog="tail -n 20 ~/vpn-warsaw.log" # pokaz ostatnie 20 wpisow logu VPN
alias vpnlog-all="cat ~/vpn-warsaw.log" # pokaz pelny log VPN

# --- Others ---
alias yt-dlp-mac="yt-dlp -f 'bestvideo[vcodec^=avc1][ext=mp4]+bestaudio[ext=m4a]' --merge-output-format mp4"
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

# Created by `pipx` on 2025-05-27 11:57:59
export PATH="$PATH:/Users/atom/.local/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$PATH:/Users/atom/.spicetify


# ══════════════════════════════════════════════════════════════════════════════
# yt-dlp aliasy — ~/.zshrc
# ══════════════════════════════════════════════════════════════════════════════

# Audio (YouTube Music) → M4A, najlepsza jakość
ytdl-audio() {
  yt-dlp --format "bestaudio[ext=m4a]/bestaudio[ext=opus]/bestaudio" --extract-audio --audio-format m4a --audio-quality 0 --embed-metadata --embed-thumbnail --no-playlist --retries 5 --output "$HOME/Music/%(uploader)s - %(title)s [%(id)s].%(ext)s" "$@"
}

# Audio → MP3
ytdl-mp3() {
  yt-dlp --format "bestaudio" --extract-audio --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --no-playlist --retries 5 --output "$HOME/Music/%(uploader)s - %(title)s [%(id)s].%(ext)s" "$@"
}

# Cała playlista muzyczna → M4A
# Użycie: ytdl-playlist URL [KATALOG]
ytdl-playlist() {
  local url="$1"
  local dir="${2:-$HOME/Music}"
  yt-dlp --format "bestaudio[ext=m4a]/bestaudio[ext=opus]/bestaudio" --extract-audio --audio-format m4a --audio-quality 0 --embed-metadata --embed-thumbnail --retries 5 --output "$dir/%(playlist)s/%(playlist_index)s - %(uploader)s - %(title)s [%(id)s].%(ext)s" "$url"
}

# Wideo H.264 + M4A → MP4 (natywne macOS/iOS)
ytdl-video() {
  yt-dlp --format "bestvideo[vcodec^=avc1][ext=mp4]+bestaudio[ext=m4a]/bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --merge-output-format mp4 --embed-metadata --embed-thumbnail --no-playlist --retries 5 --output "/Users/atom/Movies/YouTube/%(uploader)s - %(title)s [%(id)s].%(ext)s" "$@"
}

# Wideo max 1080p
ytdl-1080() {
  yt-dlp --format "bestvideo[vcodec^=avc1][height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 --embed-metadata --no-playlist --retries 5 --output "/Users/atom/Movies/YouTube/%(uploader)s - %(title)s [%(id)s].%(ext)s" "$@"
}

# Aktualizacja yt-dlp
alias ytdl-update='yt-dlp --update'
