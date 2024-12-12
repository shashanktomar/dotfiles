#!/bin/bash

set -eufo pipefail

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable swipe navigation with scroll gestures
defaults write -g AppleEnableSwipeNavigateWithScrolls -int 0

# Disable minimizing windows when double-clicking the title bar
defaults write -g AppleMiniaturizeOnDoubleClick -int 0

# Disable cursor magnification when locating the cursor
defaults write -g CGDisableCursorLocationMagnification -int 0

# Save to disk (not to iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -int 0

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Expand save panel by default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Help with aerospace window management
defaults write com.apple.dock expose-group-apps -bool true

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

# Faster Key Repeats
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true
# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -int 0
# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 3

# Disable smart stuff which is not so smart
defaults write -g NSAutomaticCapitalizationEnabled -int 0
defaults write -g NSAutomaticDashSubstitutionEnabled -int 0
defaults write -g NSAutomaticInlinePredictionEnabled -int 0
defaults write -g NSAutomaticPeriodSubstitutionEnabled -int 0
defaults write -g NSAutomaticQuoteSubstitutionEnabled -int 0
defaults write -g NSAutomaticSpellingCorrectionEnabled -int 0
defaults write -g NSAutomaticTextCorrectionEnabled -int 0
defaults write -g NSUserDictionaryReplacementItems '()'
defaults write -g WebAutomaticSpellingCorrectionEnabled -int 0

# Enable function keys, F1, F2 etc
defaults write -g com.apple.keyboard.fnState -int 1
# Disable force click and haptic feedback on the trackpad
defaults write -g com.apple.trackpad.forceClick -int 0

###############################################################################
# Dock                                                                        #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -int 1

# Don't show recently used applications in the Dock
defaults write com.apple.dock show-recents -int 0

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -int 1

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -int 0

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -int 1

# No bouncing icons
defaults write com.apple.dock no-bouncing -int 1

# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

###############################################################################
# Trackpad
###############################################################################

# Enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Finder                                                                      #
###############################################################################

# Set column view as default for finder
defaults write com.apple.finder FXPreferredViewStyle -string clmv

# Show folders on top
defaults write com.apple.finder _FXSortFoldersFirst -int 1

# Remove trash items after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -int 1

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -int 0

# Remove warning on file extension change
defaults write com.apple.finder FXEnableExtensionChangeWarning -int 0

# Allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -int 1

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -int 1

# Show all file extensions in Finder
defaults write -g AppleShowAllExtensions -int 1

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -int 1

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -int 1

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -int 1
defaults write com.apple.desktopservices DSDontWriteUSBStores -int 1

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Use AirDrop over every interface.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

###############################################################################
# Calendar                                                                    #
###############################################################################

# Week starts on monday
defaults write com.apple.iCal "first day of week" -int 1

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Address Book" "Calendar" "Contacts" "Dock" "Finder" "Mail" "Safari" "SystemUIServer" "iCal"; do
  killall "${app}" &>/dev/null || true
done
