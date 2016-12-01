#!/usr/bin/env bash

set -e

HAMMER_DIR="$HOME/.hammerspoon"
INSTALL_DIR="$HAMMER_DIR/anycomplete"
INIT_FILE="$HAMMER_DIR/init.lua"

if [ ! -d "$HAMMER_DIR" ]; then
  echo "The directory $HAMMER_DIR doesn't exist"
  echo "Is Hammerspoon installed?"
  echo "You can install Hammerspoon using:"
  echo ""
  echo "$ brew tap caskroom/cask"
  echo "$ brew cask install hammerspoon"
  echo "$ open -a /Applications/Hammerspoon.app"
  exit 1
fi

if [ -d "$INSTALL_DIR" ]; then
  echo "Anycomplete is already installed into $INSTALL_DIR"
  exit 1
fi

git clone https://github.com/nathancahill/Anycomplete.git "$INSTALL_DIR"
cat "$INSTALL_DIR/init.lua" >> "$INIT_FILE"

echo ""
echo "Anycomplete has been installed into $INSTALL_DIR"
echo "Edit $INIT_FILE to change the default keybinding"
