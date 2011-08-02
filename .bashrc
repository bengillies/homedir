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

#The bin in the home directory should take priority
PATH=$HOME/bin:$PATH

export PATH

#set up TiddlyWiki specific environment variables for use with cook
export TW_TRUNKDIR=/Users/bengillies/src/svn.tiddlywiki.org/Trunk/
export TW_ROOT=/Users/bengillies/src/svn.tiddlywiki.org/Trunk/
export OSMOSOFT=/Users/bengillies/Osmosoft/

#set the prompt to username@hostname:pwd$ with username in blue, hostname in red, pwd in green, @, : and $ in white, and all bold
PS1='\[\e[1;34m\]\u\[\e[m\]\[\e[1;37m\]@\[\e[m\]\[\e[1;31m\]\h\[\e[m\]:\[\e[1;32m\]\w\[\e[m\]\[\e[1;37m\]\$\[\e[m\]\[\e[m\]'
export PS1

#add colour to ls
alias ls='ls -G'

#add color and line numbers to grep
alias grep='grep --color -n'

#set editing mode to vi
set -o vi

#set a default editor
export EDITOR=/opt/local/bin/vim

#set a variable for dropbox (for use with git remotes)
export DROPBOX=$HOME/Dropbox

#set a variable for the downloads folder
export DOWNLOAD=$HOME/Downloads

#set java to run version 1.6 by default
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home

#alias prolog to be a sensible name
alias prolog="swipl"

#write the current directory to a file if in screen
#(so that we can use it to print the current git branch in the status bar)
if [ "$TERM" == "screen-bce" -o "$TERM" == "screen-256color" ]; then
	PROMPT_COMMAND="pwd > $HOME/.pwd"
	alias pbcopy="cat > /tmp/pipe4tmux"
fi


#start screen (unless we're in it already). If its already on, connect to it
if [ "$TERM" != "screen-bce" -a "$TERM" != "screen-256color" ]; then
	echo "connecting to tmux..."
	pipe4tmux=/tmp/pipe4tmux
	alias tcp="tmux showb > $pipe4tmux"
	if [[ ! -p $pipe4tmux ]]; then
		~/bin/pipe4tmux.sh &
	fi
	tmux attach
fi
