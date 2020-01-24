# ls
alias la="ls -alG"

# IP addres aliases
alias publicipv4="echo $(curl -s https://api.ipify.org)"
alias publicipv6="echo $(curl -s https://api6.ipify.org)"
alias publicip=publicipv4
alias wlanip="ipconfig getifaddr en0" #wireless
alias lanip="ipconfig getifaddr en8" #wired
alias ipv4="ifconfig -a | grep -o 'inet \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet //'"
alias ipv6="ifconfig -a | grep -o 'inet6 \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6 //'"
alias localip="echo \"\033[1mlan: \033[0m $(lanip)\n\033[1mwlan:\033[0m $(wlanip)\""
alias afconfig="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Finder
# TODO: Add alias to toggle show/hide hidden folders & files

# Flush Directory Service cache
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# fix openwith dupes + kill Finder + open TotalFinder
alias lscleanup='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder && open /Applications/TotalFinder.app'

# SSH
alias pubkey="pbcopy < ~/.ssh/id_rsa.pub"
