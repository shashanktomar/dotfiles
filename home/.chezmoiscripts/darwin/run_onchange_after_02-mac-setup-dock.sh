#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/kitty.app"

killall Dock
