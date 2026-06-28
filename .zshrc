# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Java
export JAVA_OPTS="-Xmx4g -Xms2g"

# Shell config
alias edz="vi ~/.zshrc"
alias srz="source ~/.zshrc"

# Navigation
alias cdwn="cd ~/Downloads"
alias cdev="cd ~/Documents/dev"
alias cdsk="cd ~/Desktop"
alias cdpe="cd ~/Documents/dev/workspace-pe"

# Docker
alias dp="docker ps"
alias dl="docker logs"

# Claude Code
alias cc="claude"
alias ccc="claude -c"
alias ccr="claude -r"
