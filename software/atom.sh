#!/usr/bin/env bash

###############################################################################
# ATOM                                                                        #
###############################################################################

brew cask install atom
# TODO: Configure atom options
# "welcome": {
# 	"showOnStartup": false
# }

# themes
apm install dracula-ui # UI
apm install gloom # Syntax
# TODO: Set ui & syntax theme
# "core": {
#   ...
#   "themes": [
#     "dracula-ui",
#     "gloom"
#   ],
#   "titleBar": "custom-inset"
# },

# nuclide config
apm install nuclide
# TODO: Configure nuclide options
# "nuclide": {
# 	"installRecommendedPackages": true,
# 	"use": {
# 		"atom-ide-diagnostics-ui": "never"
# 	}
# },

# prettier-atom
apm install linter # dependency of prettuer
apm install linter-ui-default
apm install intentions
apm install busy-signal
apm install prettier-atom
# TODO: Configure prettier-atom options
# "prettier-atom": {
# 	"useEslint": true
# },
