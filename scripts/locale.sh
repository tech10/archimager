#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define the locale
LOCALE="en_US.UTF-8"
KEYMAP="us"

echo "Setting up locale $LOCALE and keymap $KEYMAP"

# Enable the locale in /etc/locale.gen
if grep -q "^#${LOCALE}" /etc/locale.gen; then
  sed -i "s/^#${LOCALE}/${LOCALE}/" /etc/locale.gen
  echo "$LOCALE enabled in /etc/locale.gen"
else
  echo "$LOCALE is already enabled in /etc/locale.gen or doesn't exist"
fi

# Generate the locale
echo "Generating locale..."
locale-gen

# Set the system locale
echo "Setting system locale with localectl..."
localectl set-locale $LOCALE

# Set the keymap
echo "Setting keymap to $KEYMAP with localectl..."
localectl set-keymap $KEYMAP

echo "Locale and keymap setup completed."
