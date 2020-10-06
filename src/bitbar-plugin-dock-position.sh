#!/bin/bash

#
# Lightweight Dock position switcher
#
# Author: Tim Schmelter
#

# metadata
# <bitbar.title>Dock position switcher</bitbar.title>
# <bitbar.version>v0.0.1</bitbar.version>
# <bitbar.author>Tim Schmelter</bitbar.author>
# <bitbar.author.github>palpatim</bitbar.author.github>
# <bitbar.desc>Display current Xcode version and switch to others</bitbar.desc>
# <bitbar.abouturl>https://github.com/palpatim/bitbar-plugin-xcode-version</bitbar.abouturl>

###############################################################################
# bitbar-plugin-dock-position.sh
# Displays the current position of the dock, and allows switching the doc
# position
###############################################################################

function get_icon_for_dock_position {
  declare -r position=$1
  case $position in
    left)
      echo "⇐"
      ;;
    bottom)
      echo "⇓"
      ;;
    right)
      echo "⇒"
      ;;
    *)
      echo "?"
  esac
}

function get_dock_position {
  defaults read com.apple.dock orientation
}

function get_plugin_directory {
  declare -r link=$( readlink $0 )
  if [[ -n "$link" ]] ; then
    dir=$( dirname "$link" )
    echo "${dir}"
  else
    echo $PWD
  fi
}

function get_switch_script {
  local dir=$( get_plugin_directory )
  echo "${dir}/switch-dock-position.sh"
}


###############################################################################
# MAIN
###############################################################################
switch_script=$( get_switch_script )

current_position=$( get_dock_position )
current_icon=$( get_icon_for_dock_position "$current_position" )

echo "$current_icon"

echo "---"

for position in left bottom right ; do
  if [[ "$current_position" = "$position" ]] ; then
    echo "Currently ${current_position} (${current_icon})"
  else
    icon=$( get_icon_for_dock_position "$position" )
    #echo "Switch dock to ${position} (${icon}) | bash=defaults param1=write param2=com.apple.dock param3=orientation param4=${position} terminal=false refresh=true"
    echo "Switch to ${position} (${icon}) | bash=${switch_script} param1=${position} terminal=false refresh=true"
  fi
done
