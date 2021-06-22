#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/iTerm.app"

killall Dock