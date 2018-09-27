#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOTING THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
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
source ~/.bash_profile

nvm install 7
nvm install 9
nvm use default 9

NPM_USER=""
echo -e "\nWhat's your npm username?"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && NPM_USER=$REPLY

if [ "$NPM_USER" != "" ]; then
	npm adduser $NPM_USER
fi;


###############################################################################
# RVM                                                                         #
###############################################################################

curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.profile


###############################################################################
# Mac App Store                                                               #
###############################################################################

brew install mas

# Apple ID
if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
	AppleID=""
else
	AppleID="$(defaults read NSGlobalDomain AppleID)"
fi;
echo -e "\nWhat's your Apple ID? (default: $AppleID)"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && AppleID=$REPLY

if [ "$AppleID" != "" ]; then

	# Sign in
	mas signin $AppleID

	# Tweetbot + config
	mas install 557168941 # Tweetbot
	defaults write com.tapbots.TweetbotMac OpenURLsDirectly -bool true

	# iWork
	mas install 409203825 # Numbers
	mas install 409201541 # Pages
	mas install 409183694 # Keynote

	# Others
	mas install 494803304 # Wifi Explorer
	mas install 425424353 # The Unarchiver
	mas install 404167149 # IP Scanner
	mas install 402397683 # MindNode Lite
	mas install 578078659 # ScreenSharingMenulet
	mas install 803453959 # Slack
	mas install 1006739057 # NepTunes (Last.fm Scrobbling)
	mas install 955297617 # CodeRunner 2
	mas install 1313773050 # Artstudio Pro
	mas install 824171161 # Affinity Designer
	mas install 824183456 # Affinity Photo

fi;


###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew cask install google-chrome


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

npm install -g react-native-cli

brew install yarn --without-node
echo "# Yarn" >> ~/.bash_profile
echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

brew install watchman
# Watchman needs permissions on ~/Library/LaunchAgents
if [ ! -d "~/Library/LaunchAgents" ]; then
	sudo chown -R $(whoami):staff ~/Library/LaunchAgents
else
	mkdir ~/Library/LaunchAgents
fi;

brew cask install react-native-debugger

brew install --HEAD libimobiledevice
gem install xcpretty


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
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Tansmission/.incomplete"
if [ ! -d "${HOME}/Downloads/Transmission/.incomplete" ]; then
	mkdir -p ${HOME}/Downloads/Transmission/.incomplete
fi;

# Use `~/Downloads/_COMPLETE` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/Transmission"
if [ ! -d "${HOME}/Downloads/Transmission/" ]; then
	mkdir -p ${HOME}/Downloads/Transmission
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

brew install tig

brew install speedtest-cli
brew install jq

brew cask install 1password
brew cask install macpass

brew cask install caffeine
# brew cask install nosleep

brew cask install day-o
brew cask install deltawalker
brew cask install macpar-deluxe

brew cask install vlc
duti -s org.videolan.vlc public.avi all
# brew cask install plex-media-server

brew cask install charles
brew cask install ngrok

brew cask install slack
brew cask install hipchat

brew cask install tower
brew cask install dropbox
brew cask install transmit4

brew cask install handbrake
brew cask install spectacle

brew install mkvtoolnix
brew cask install makemkv
brew cask install jubler
brew cask install flixtools

brew cask install the-archive-browser
brew cask install imagealpha
brew cask install colorpicker-skalacolor

brew cask install steam
brew cask install xact

brew cask install postman

# Locking down to this version (no serial for later version)
brew cask install https://raw.githubusercontent.com/grettir/homebrew-cask/36b240eeec68e993a928395d3afdcef1e32eb592/Casks/screenflow.rb

brew cask install subsurface
brew cask install quik


###############################################################################
# Android Studio                                                              #
###############################################################################

# @ref https://gist.github.com/agrcrobles/165ac477a9ee51198f4a870c723cd441
# @ref https://gist.github.com/spilth/e7385e7f5153f76cca40a192be35f4ba

touch ~/.android/repositories.cfg

# Android Dev Tools
brew cask install caskroom/versions/java8
brew install ant
brew install maven
brew install gradle
# brew install qt
brew cask install android-sdk
brew cask install android-ndk

# SDK Components
sdkmanager "platform-tools" "platforms;android-25" "extras;intel;Hardware_Accelerated_Execution_Manager" "build-tools;25.0.3" "system-images;android-25;google_apis_playstore;x86" "emulator"
# echo y | …

# HAXM
if [ $(sw_vers -productVersion | cut -d. -f2) -lt 13 ]; then
	brew cask install intel-haxm
else
	echo -e "\n\033[93mCould not install intel-haxm on this OS. It's not supported (yet)\033[0m\n"
fi;

# ENV Variables
echo 'export ANT_HOME=/usr/local/opt/ant' >> ~/.bash_profile
echo 'export MAVEN_HOME=/usr/local/opt/maven' >> ~/.bash_profile
echo 'export GRADLE_HOME=/usr/local/opt/gradle' >> ~/.bash_profile
echo 'export ANDROID_HOME=/usr/local/share/android-sdk' >> ~/.bash_profile
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.bash_profile
echo 'export ANDROID_AVD_HOME="$HOME/.android/avd"' >> ~/.bash_profile
echo 'export ANDROID_NDK_HOME=/usr/local/share/android-ndk' >> ~/.bash_profile
echo 'export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm' >> ~/.bash_profile

echo 'export PATH="$ANT_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$MAVEN_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$GRADLE_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/tools:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/build-tools/25.0.3:$PATH"' >> ~/.bash_profile
# @ref https://www.bram.us/2017/05/12/launching-the-android-emulator-from-the-command-line/
echo 'export PATH="$ANDROID_HOME/emulator:$PATH"' >> ~/.bash_profile

source ~/.bash_profile

# Android Studio itself
brew cask install android-studio

# Configure Emulator
# @ref https://gist.github.com/Tanapruk/b05e97d68a5969b4402650094145e913
# @ref https://wiki.genexus.com/commwiki/servlet/wiki?14462,Creating+an+Android+Virtual+Device,
# @ref https://gist.github.com/handstandsam/f20c2fd454d3e3948f428f62d73085df
echo no | avdmanager create avd --name "Nexus_5X_API_25" --abi "google_apis_playstore/x86" --package "system-images;android-25;google_apis_playstore;x86" --device "Nexus 5X" --sdcard 128M

echo "vm.heapSize=256
hw.ramSize=1536
disk.dataPartition.size=2048MB
hw.gpu.enabled=yes
hw.gpu.mode=auto
hw.keyboard=yes
showDeviceFrame=yes
skin.dynamic=yes
skin.name=nexus_5x
skin.path=$HOME/Library/Android/sdk/skins/nexus_5x" >> ~/.android/avd/Nexus_5X_API_25.avd/config.ini

# Start it via `emulator -avd Nexus_5X_API_25`

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
