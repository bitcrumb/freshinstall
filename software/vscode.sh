#!/usr/bin/env bash

###############################################################################
# VSCODE                                                                      #
###############################################################################

brew cask install visual-studio-code

# Extensions
code --install-extension mikestead.dotenv
code --install-extension dbaeumer.vscode-eslint
code --install-extension flowtye.flow-for-vscode
code --install-extension andys8.jest-snippets
code --install-extension vsmobile.vscode-react-native
code --install-extension wayou.vscode-todo-highlight
code --install-extension prettier-vscode
code --install-extension adamgirton.gloom # ui theme
code --install-extension dracula-theme.theme-dracula # syntax theme
# TODO: Set gloom & dracula theme as defaults
