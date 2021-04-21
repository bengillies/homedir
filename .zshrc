#{{{ Colors and prompt
autoload -U colors && colors

setopt prompt_subst

ORANGE=$'\033[38;5;173m'
YELLOW=$'\033[38;5;221m'
GREEN=$'\033[38;5;72m'
BLUE=$'\033\[38;5;117m'

# prev_cmd_status pwd                                               gitbranch[status]
function happy_or_sad_or_ssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		echo 👽
	else
		echo "%(?.😃.😡)"
	fi
}

# current vi mode status (i.e. insert mode or command mode) or jobs or root (i.e. # or %)
function command_mode_or_jobs() {
	if [ "$VIMODE" '==' "M:command" ]; then
		echo "✏️ "
	else
		echo " %(1j.%j.%#)"
	fi
}

function precmd() {
	PROMPT="$(happy_or_sad_or_ssh)  %{$GREEN%}%~%{$reset_color%} $(command_mode_or_jobs) "
	RPROMPT="%{$BLUE%}$(ginfo)%{$reset_color%}"
}
#}}}

# load some modules
autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup

# pipe to multiple outputs
setopt MULTIOS

# spell check commands
setopt CORRECT

#{{{ Globbing
setopt GLOB_COMPLETE
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB
#}}}

#{{{ Vi mode stuff
setopt VI
export EDITOR=vim
set -o vi

# set VIMODE variable to M:command when in command mode
function zle-line-init zle-keymap-select {
	VIMODE="${${KEYMAP/vicmd/M:command}/(main|viins)/}"
	precmd
	zle reset-prompt
}

# load plugins
zle -N zle-line-init
zle -N zle-keymap-select
#}}}

# better array expansion
setopt RC_EXPAND_PARAM

#{{{ Key bindings
# C-r is reverse history search
bindkey "^R" history-incremental-search-backward

# C-z brings the most recently stopped job (usually Vim) back to the foreground
function bring-to-fg() {
	fg
}
zle -N bring-to-fg
bindkey "^Z" bring-to-fg
#}}}

#{{{ History
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
#}}}

#{{{ Aliases
#add colour to ls
alias ls='ls -G'

#add color and line numbers to grep and ignore binary file matches
alias grep='grep --color -n -I -R'

#don't try and correct lein to link
alias lein='nocorrect lein'

#g == git
alias g='git'

#manually specify unicorn startup
#alias runicorn='bundle exec unicorn_rails -p 3000 -c ~/.unicorn.conf'
#}}}

#{{{ Folder locations
#set a variable for dropbox (for use with git remotes)
export DROPBOX=$HOME/Dropbox

#set a variable for the downloads folder
export DOWNLOAD=$HOME/Downloads

#set java to run version 1.8 by default
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home

#export a NODE_PATH variable to pick up scripts installed by npm
export NODE_PATH=/usr/local/lib/node_modules

#add jsctags to the NODE_PATH
export NODE_PATH=/usr/local/lib/jsctags:$NODE_PATH
#}}}

#{{{ Path variable
#add some sensible extra paths
PATH=/usr/local/bin:/usr/sbin:$PATH

#add git
PATH=/usr/local/git/bin:$PATH

#add modern python
PATH=/usr/local/opt/python@3.8/bin:$PATH

#add mysql
PATH=/usr/local/mysql/bin:$PATH

#add the android sdk
PATH=/usr/local/android/tools:~/Library/Android/sdk/tools:~/Library/android/sdk/platform-tools:$PATH

#add Java 1.6
PATH=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home/bin:$PATH

#add the cabal bin for haskell programs
PATH=$HOME/.cabal/bin:$PATH

#npm binaries
PATH=/usr/local/share/npm/bin:$PATH

#set up rbenv paths
PATH=$HOME/.rbenv/bin:$PATH
PATH=$HOME/.rbenv/versions/2.0.0-p481/bin:$PATH
eval "$(rbenv init - -zsh --no-rehash)"

#set up nvm paths
export NVM_DIR="$HOME/.nvm"
export PATH="$NVM_DIR/versions/node/v$(<$NVM_DIR/alias/default)/bin:$PATH"
alias nvm='unalias nvm; [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"; nvm $@'

#load in autocomplete helpers
source <(kubectl completion zsh)

#The bin in the home directory should take priority
PATH=$HOME/bin:$PATH

export PATH
#}}}

#start tmux (unless we're in it already). If its already on, connect to it
if [ "$TERM" != "screen-bce" -a "$TERM" != "screen-256color" ] && tty -s; then
	echo "connecting to tmux..."
	tmux attach-session
fi
