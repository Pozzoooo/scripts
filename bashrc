#basic
alias l=ls
alias ll=ls
alias sl=ls
alias bim=vim
alias grep=grep --color=auto

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

