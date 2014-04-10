#!/bin/sh
# Run this to generate all the initial makefiles, etc.

which gnome-autogen.sh || {
    echo "You need to install gnome-common from GNOME git (or from your OS vendor's package manager)."
    exit 1
}

REQUIRED_AUTOMAKE_VERSION=1.9

. gnome-autogen.sh
