#Add it to ~/.basrc like this: . ~/dev/projs/scripts/bashrc

#
# esc . ctrl + e = expand alias
# esc + * = expand autocomplition
#

#has to be set to scripts folder manually
DIR="~/dev/projs/scripts"
alias and="$DIR/android.sh"
alias hlp="$DIR/helper.sh"

#basic
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ld='ls -d' #great to filter directories
alias c='clear'

#error correction
alias bim=vim
alias grep=grep --color=auto
alias sl=ls

#alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#Android helper
alias paste='adb shell input text'
alias devid="adb devices | tail -n +2 | cut -sf 1"
alias startintent="devid | xargs -I X adb -s X shell am start $1"
alias apkinstall="devid | xargs -I X adb -s X install -r $1"
alias rmapp="devid | xargs -I X adb -s X uninstall $1"
alias clearapp="devid | xargs -I X adb -s X shell pm clear $1"

# gradle
alias g="./gradlew --stacktrace --daemon"
alias gc="g clean"
alias gd="g assembleDebug"

#git
alias gitconfig="git config --global"

