# ls
alias la="ls -alG"

# IP addres aliases
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0" #wireless
alias ipv4="ifconfig -a | grep -o 'inet \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet //'"
alias ipv6="ifconfig -a | grep -o 'inet6 \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6 //'"
alias afconfig="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Finder
# TODO: Add alias to toggle show/hide hidden folders & files

# Flush Directory Service cache
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# fix openwith dupes + kill Finder + open TotalFinder
alias lscleanup='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder && open /Applications/TotalFinder.app'

# SSH
alias pubkey="pbcopy < ~/.ssh/id_rsa.pub"

# Remember SSH Keys between reboots
# @ref http://apple.stackexchange.com/questions/254468/macos-sierra-doesn-t-seem-to-remember-ssh-keys-between-reboots
ssh-add -A &> /dev/null
