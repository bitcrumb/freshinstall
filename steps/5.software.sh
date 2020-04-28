#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOTING THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=$(basename "$0")
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be run by itself."
	echo -e "Please launch freshinstall itself using \033[1m./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;

###############################################################################
# NVM + Node Versions                                                         #
###############################################################################

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.zshrc

nvm install 10
nvm install 12
nvm use default 12

NPM_USER=""
echo -e "\nWhat's your npm username?"
echo -ne "> \033[34m\a"
read -r
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && NPM_USER=$REPLY

if [ "$NPM_USER" != "" ]; then
	npm adduser "$NPM_USER"
fi;


###############################################################################
# Node based tools                                                            #
###############################################################################

npm install -g node-notifier-cli
npm install -g gitmoji-cli
npm install -g spaceship-prompt

###############################################################################
# RVM                                                                         #
###############################################################################

curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
source ~/.profile


###############################################################################
# Mac App Store                                                               #
###############################################################################

brew install mas

# Apple ID
if defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$"; then
	AppleID=""
else
	AppleID="$(defaults read NSGlobalDomain AppleID)"
fi;
echo -e "\nWhat's your Apple ID? (default: $AppleID)"
echo -ne "> \033[34m\a"
read -r
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && AppleID=$REPLY

if [ "$AppleID" != "" ]; then

	# Sign in
	mas signin "$AppleID"

	# Tweetbot + config
	mas install 557168941 # Tweetbot
	defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

	# iWork
	mas install 409203825 # Numbers
	mas install 409201541 # Pages
	mas install 409183694 # Keynote

	# Others
	mas install 1408727408 # Wifi Explorer Lite
	mas install 425424353 # The Unarchiver
	mas install 404167149 # IP Scanner
	mas install 803453959 # Slack
	mas install 411643860 # DaisyDisk
	mas install 407963104 # Pixelmator
	mas install 1039633667 # Irvue
	mas install 1480068668 # Messenger

fi;


###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew cask install google-chrome
brew cask install firefox

###############################################################################
# FONTS                                                                       #
###############################################################################

brew tap homebrew/cask-fonts
brew cask install font-inconsolata
brew cask install font-ibm-plex
brew cask install font-firacode-nerd-font-mono

###############################################################################
# ITERM                                                                       #
###############################################################################

brew cask install iterm2
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install shellcheck
# TODO: configure iTerm theme (& font)


###############################################################################
# MESSENGERS                                                                  #
###############################################################################

brew cask install whatsapp
brew cask install caprine # facebook messenger
brew cask install slack
brew cask install discord


###############################################################################
# IMAGE & VIDEO PROCESSING                                                    #
###############################################################################

brew install imagemagick --with-librsvg --with-opencl --with-webp

brew install libvpx
brew install ffmpeg --with-libass --with-libvorbis --with-libvpx --with-x265 --with-ffplay
brew install youtube-dl


###############################################################################
# REACT NATIVE + TOOLS                                                        #
###############################################################################

npm install -g expo-cli

brew install ios-deploy
brew install watchman
# Watchman needs permissions on ~/Library/LaunchAgents
if [ ! -d "$HOME/Library/LaunchAgents" ]; then
	sudo chown -R "$(whoami):staff ~/Library/LaunchAgents"
else
	mkdir ~/Library/LaunchAgents
fi;

brew cask install react-native-debugger
brew cask install reactotron

brew install --HEAD libimobiledevice
gem install xcpretty
gem install bundler


###############################################################################
# QUICK LOOK PLUGINS                                                          #
###############################################################################

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlimagesize
brew cask install suspicious-package
brew cask install qlvideo

brew cask install provisionql
brew cask install quicklookapk

# restart quicklook
defaults write org.n8gray.QLColorCode extraHLFlags '-l'
qlmanage -r
qlmanage -m


###############################################################################
# Transmission.app + Config                                                   #
###############################################################################

# Install it
brew cask install transmission

# Use `~/Downloads/_INCOMING` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Transmission/.incomplete"
if [ ! -d "${HOME}/Downloads/Transmission/.incomplete" ]; then
	mkdir -p "${HOME}/Downloads/Transmission/.incomplete"
fi;

# Use `~/Downloads/_COMPLETE` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/Transmission"
if [ ! -d "${HOME}/Downloads/Transmission/" ]; then
	mkdir -p "${HOME}/Downloads/Transmission"
fi;

# Autoload torrents from Downloads folder
defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Don’t prompt for confirmation before removing non-downloading active transfers
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
# defaults write org.m0k.transmission RandomPort -bool true

# Set UploadLimit
defaults write org.m0k.transmission SpeedLimitUploadLimit -int 10
defaults write org.m0k.transmission UploadLimit -int 5

###############################################################################
# OTHER BREW/CASK THINGS                                                      #
###############################################################################

brew cask install google-drive-file-stream
brew cask install google-backup-and-sync

brew cask install 1password
brew cask install alfred
brew cask install zoomus

brew cask install spotify
brew cask install iina
brew cask install vlc
brew install duti
duti -s org.videolan.vlc public.avi all

brew tap homebrew/cask-drivers
brew cask install sonos

brew cask install zeplin
brew cask install sketch
brew cask install figma
brew cask install framer-x

brew cask install moom
brew cask install choosy

brew cask install charles
brew cask install postman
brew cask install fork

brew cask install macdown
brew cask install adobe-acrobat-reader
brew cask install notion

brew cask install microsoft-office

brew cask install daisydisk
brew cask install little-snitch
brew cask install paparazzi

brew cask install netnewswire

###############################################################################
# VSCODE                                                                      #
###############################################################################

brew cask install visual-studio-code
code --install-extension shan.code-settings-sync # the only extension we need, it backups & sync settings & extensions

echo -e "\n\033[93m>To import all settings & extensions of Visual Studio Code, couple your\033[0m"
echo -e "\033[93mGithub account and download them through the 'Sync Settings' extensions.\033[0m\n"

###############################################################################
# ALL DONE NOW!                                                               #
###############################################################################

echo -e "\n\033[93mSo, that should've installed all software for you …\033[0m"
echo -e "\n\033[93mYou'll have to install the following manually though:\033[0m"

echo "- Additional Tools for Xcode"
echo ""
echo "    Download from https://developer.apple.com/download/more/"
echo "    Mount the .dmg + install it from the Graphics subfolder"
echo ""
