#add some sensible extra paths
PATH=/usr/local/bin:/usr/sbin:$PATH

#add cook and ginsu
PATH=/Users/bengillies/src/svn.tiddlywiki.org/Trunk/tools/cooker/bash/:$PATH

#add git
PATH=/usr/local/git/bin:$PATH

#add mysql
PATH=/usr/local/mysql/bin/:$PATH

#add the android sdk
PATH=/usr/local/android/tools:$PATH

#add Java 1.6
PATH=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home/bin:$PATH

#add /opt/local/bin for MacPorts installed apps
PATH=/opt/local/bin:/opt/local/sbin:$PATH

#add the cabal bin for haskell programs
PATH=$HOME/.cabal/bin:$PATH

#set up rbenv paths
PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - --no-rehash)"

#The bin in the home directory should take priority
PATH=$HOME/bin:$PATH

export PATH

#set up TiddlyWiki specific environment variables for use with cook
export TW_TRUNKDIR=/Users/bengillies/src/svn.tiddlywiki.org/Trunk/
export TW_ROOT=/Users/bengillies/src/svn.tiddlywiki.org/Trunk/
export OSMOSOFT=/Users/bengillies/Osmosoft/


#Prompt is cmd:repo/branch:cwd$ in colors yellow:blue:green$
PS1='\[\e[38;5;221m\]\!\[\e[m\]:\[\e[38;5;117m\]$(ginfo)\[\e[m\]:\[\e[38;5;72m\]\w\[\e[m\]\$'
#set the prompt to username@hostname:pwd$ with username in blue, hostname in red, pwd in green, @, : and $ in white, and all bold
#PS1='\[\e[38;5;117m\]\u\[\e[m\]\[\e[38;5;230m\]@\[\e[m\]\[\e[38;5;221m\]\h\[\e[m\]:\[\e[38;5;72m\]\w\[\e[m\]\[\e[38;5;230m\]\$\[\e[m\]\[\e[m\]'
export PS1


#add colour to ls
alias ls='ls -G'

#add color and line numbers to grep and ignore binary file matches
alias grep='grep --color -n -I -R'

#set editing mode to vi
set -o vi

#set a default editor
export EDITOR=/usr/bin/vim

#set a variable for dropbox (for use with git remotes)
export DROPBOX=$HOME/Dropbox

#set a variable for the downloads folder
export DOWNLOAD=$HOME/Downloads

#set java to run version 1.6 by default
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home

#alias prolog to be a sensible name
alias prolog="swipl"

#export a NODE_PATH variable to pick up scripts installed by npm
export NODE_PATH=/usr/local/lib/node_modules

#add jsctags to the NODE_PATH
export NODE_PATH='/usr/local/lib/jsctags:${NODE_PATH}'
#start screen (unless we're in it already). If its already on, connect to it
if [ "$TERM" != "screen-bce" -a "$TERM" != "screen-256color" ] && tty -s; then
	echo "connecting to tmux..."
	tmux attach
fi
