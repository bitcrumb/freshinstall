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

nvm install 8
nvm install 10
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
# Node based tools                                                            #
###############################################################################

npm i -g node-notifier-cli


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
	mas install 1408727408 # Wifi Explorer Lite
	mas install 425424353 # The Unarchiver
	mas install 404167149 # IP Scanner
	mas install 803453959 # Slack
	mas install 411643860 # DaisyDisk

fi;


###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew cask install google-chrome
brew cask install firefox

###############################################################################
# FONTS                                                                       #
###############################################################################

# TODO: Download IBM Plex font and move it to ~/Library/Fonts


###############################################################################
# ITERM                                                                       #
###############################################################################

brew cask install iterm2

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

npm install -g react-native-cli

brew install watchman
# Watchman needs permissions on ~/Library/LaunchAgents
if [ ! -d "~/Library/LaunchAgents" ]; then
	sudo chown -R $(whoami):staff ~/Library/LaunchAgents
else
	mkdir ~/Library/LaunchAgents
fi;

brew cask install react-native-debugger
brew cask install reactotron

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
<<<<<<< HEAD
=======
# Composer + MySQL + Valet                                                    #
###############################################################################

# Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "# Composer" >> ~/.bash_profile
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# Composer Autocomplete
# brew install bash-completion
curl -#L https://github.com/bramus/composer-autocomplete/tarball/master | tar -xzv --strip-components 1 --exclude={LICENSE,README.md}
mv ./composer-autocomplete ~/composer-autocomplete
echo "" >> ~/.bash_profile
echo 'if [ -f "$HOME/composer-autocomplete" ] ; then' >> ~/.bash_profile
echo '    . $HOME/composer-autocomplete' >> ~/.bash_profile
echo "fi" >> ~/.bash_profile
source ~/.bash_profile

# PHP Versions
brew install php

brew services start php
brew link php

pecl install mcrypt-1.0.1 # mcrypt for PHP > 7.1
pecl install grpc # needed for google firestore et al

# @note: You might wanna "sudo brew services restart php" after this

# MySQL
brew install mysql
brew services start mysql

# Tweak MySQL
mysqlpassword="root"
echo -e "\n  What should the root password for MySQL be? (default: $mysqlpassword)"
echo -ne "  > \033[34m\a"
read
echo -e "\033[0m\033[1A"
[ -n "$REPLY" ] && mysqlpassword=$REPLY

mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '$mysqlpassword'; FLUSH PRIVILEGES;"
cat ./resources/apps/mysql/my.cnf > /usr/local/etc/my.cnf
brew services restart mysql

# Laravel Valet
composer global require laravel/valet
valet install

# If you want PMA available over https://pma.test/, run this:
# cd ~/repos/misc/
# composer create-project phpmyadmin/phpmyadmin
# cd ~/repos/misc/phpmyadmin
# valet link pma
# valet secure

###############################################################################
>>>>>>> bramus/master
# Transmission.app + Config                                                   #
###############################################################################

# Install it
brew cask install transmission

# Use `~/Downloads/_INCOMING` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Transmission/.incomplete"
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

brew cask install google-drive-file-stream
brew cask install google-backup-and-sync

brew cask install 1password
brew cask install alfred
brew cask install zoomus

brew cask install spotify
brew cask install iina
brew cask install vlc
duti -s org.videolan.vlc public.avi all

brew cask install zeplin
brew cask install sketch
brew cask install figma
brew cask install framer-x

brew cask install moom

brew cask install charles
brew cask install postman
brew cask install fork

<<<<<<< HEAD
brew cask install macdown
brew cask install adobe-acrobat-reader
brew cask install notion
=======
# Locking down to this version (no serial for later version)
brew cask install https://raw.githubusercontent.com/grettir/homebrew-cask/36b240eeec68e993a928395d3afdcef1e32eb592/Casks/screenflow.rb

brew cask install subsurface
brew cask install quik

brew cask install veracrypt

###############################################################################
# Virtual Machines and stuff                                                  #
###############################################################################

# Locking down to this version (no serial for later version)
brew cask install https://raw.githubusercontent.com/caskroom/homebrew-cask/a56c5894cc61d2bf182b7608e94128065af3e64f/Casks/vmware-fusion.rb
brew cask install docker

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
>>>>>>> bramus/master

brew cask install microsoft-office

brew cask install daisydisk
brew cask install little-snitch
brew cask install paparazzi

source ./software/vscode.sh

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
