#### ALIAS ####
## 
## Commands
##
# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS -1'
alias ll='ls $LS_OPTIONS -alh'
alias la='ls $LS_OPTIONS -R1'

# remove directory
alias rd='rm -rf'

# a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias ~='cd ~'

# Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# handy short cuts #
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# shorcut to connect as root
alias root='sudo su'

# Extract a file according to its type
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.lzma)      unlzma $1      ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x -ad $1 ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

## 
## Files
##
## shortcut for nano
alias n='nano'
# use colordiff package
alias diff='colordiff'

# Search all files ($1) on system using locate database
function loi() { locate -i "$1" | grep -i --color "$1"; }  # case-insensitive
function lo() { locate "$1" | grep --color "$1"; }         # case-sensitive
# find file or directory ($1) in given path ($2) within max depth ($3)
function f() {
path="."
if [ ! -z "$2" ]
then
    path="$2"
fi
maxdepth=""
if [ ! -z "$3" ]
then
    maxdepth="-maxdepth $3"
fi
find -L $path $maxdepth -iname "*$1*" -print 2>/dev/null
}
# find file ($1) in given path ($2) within max depth ($3)
function ff() {
path="."
if [ ! -z "$2" ]
then
    path="$2"
fi
maxdepth=""
if [ ! -z "$3" ]
then
    maxdepth="-maxdepth $3"
fi
find -L $path $maxdepth -type f -iname "*$1*" -print 2>/dev/null
}
# find directory ($1) in given path ($2) within max depth ($3)
function fd() {
path="."
if [ ! -z "$2" ]
then
    path="$2"
fi
maxdepth=""
if [ ! -z "$3" ]
then
    maxdepth="-maxdepth $3"
fi
find -L $path $maxdepth -type d -iname "*$1*" -print 2>/dev/null
}
# Find a file with pattern ($1) in name within a path ($2) and Execute ($3) on it:
function fe()
{ find -L $2 -type f -iname '*'$1'*' -exec ${@:3} {} \;  ; }

# Find a pattern in a set of files and highlight them:
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" path [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find -L $2 -type f -name "${3:-*}" -print0 2>/dev/null | \
    xargs -0 grep --color=always -sn ${case} "$1" 2>&- | more
}

# Shorcut for logs
# Display the end of a log file
# Without arguments : display list the log directory
# With arguments : display the end of the log file (second argument indicate the number of line)
function logs()
{
        if [ -z "$1" ]; then
                ls --color=auto -lh /var/logs
        else
                line=15
                if [ ! -z $2 ]
                then
                        line=$2
                fi
                for log in $(ls -d -1 /var/logs/* | grep $1); do
                        echo "<== $log ==>"
                        tail -$line $log;
                        echo
                done
        fi
}
# Search a pattern in all log files
function logf()
{
        if [ "$#" -lt 1 ]; then
                echo "Usage : logf \"pattern\""
                return;
        fi
        find -L /var/logs -name "*.log" -print0 | xargs -0 grep --color=always -sn "$1" 2>&- | more
}

## 
## System
##
#Restart systemctl application
alias restart='sudo systemctl restart'

#Show open ports
alias ports='netstat -tulanp'
# update on one command
alias install='sudo apt-get install'
alias update='sudo apt-get update && sudo apt-get upgrade'
## pass options to free ##
alias meminfo='free -m -l -t'
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
## Get server cpu info ##
alias cpuinfo='lscpu'
## Get processs info on a separate page ##
alias pp="ps axuf | pager"
## set some other defaults ##
alias df='df -H'
alias du='du -ch'
# top is atop, just like vi is vim
alias top='sudo atop'
# find a running process
function psg()
{
    ps axuf | grep -v grep | grep "$@" -i --color=auto;
}

# Nginx
alias sites='cd /etc/nginx/sites-available'

alias updatealiases='sudo wget -N -P /home/azrael/ https://github.com/lphaweb/debian-aliases/raw/refs/heads/main/.bash_aliases && sudo wget -N -P /root/ https://github.com/lphaweb/debian-aliases/raw/refs/heads/main/.bash_aliases'
