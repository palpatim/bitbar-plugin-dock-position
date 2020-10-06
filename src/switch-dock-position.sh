#!/bin/bash

declare -r position="${1:-bottom}"
defaults write com.apple.dock orientation "${position}"
killall Dock
