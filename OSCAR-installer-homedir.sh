#!/bin/sh

########################################
#            OSCAR installer           #
# Install OSCAR to your home directory #
# Uses GitHub API to get latest bundle #
########################################

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Set install directory
INSTALLDIR="$HOME"

# Error handling function
handle_error() {
    echo "${RED}Error: $1${NC}"
    echo "Please consider filing an issue:"
    echo "${YELLOW}https://github.com/JoshPaulie/OSCAR/issues"; exit 1
}

# Gather latest release details via GitHub API
LATESTRELEASEINFO=$(curl -s https://api.github.com/repos/joshpaulie/OSCAR/releases/latest) || handle_error "Failed to fetch latest release info."
LATESTRELEASEDOWNLOAD=$(echo "$LATESTRELEASEINFO" | grep "browser_download_url.*zip" | cut -d '"' -f 4)
LATESTRELEASETAG=$(echo "$LATESTRELEASEINFO" | grep "tag_name" | cut -d '"' -f 4)

[ -z "$LATESTRELEASEDOWNLOAD" ] && handle_error "Failed to parse release download url."
[ -z "$LATESTRELEASETAG" ] && handle_error "Failed to parse release tag."

# Install latest bundle
echo "${YELLOW}Downloading${NC} OSCAR archive to $INSTALLDIR.."
curl -sL -o "$INSTALLDIR/OSCAR.zip" "$LATESTRELEASEDOWNLOAD" || handle_error "Failed to download OSCAR archive."

# Remove existing install
if [ -d "$INSTALLDIR/OSCAR.app" ]; then
    echo "${RED}Removing${NC} existing $INSTALLDIR/OSCAR.app.."
    rm -fr "$INSTALLDIR/OSCAR.app"
fi

# Decompress archive
echo "${CYAN}Decompressing${NC} OSCAR archive.."
tar -xf "$INSTALLDIR/OSCAR.zip" --directory "$INSTALLDIR" || handle_error "Failed to decompress OSCAR archive."

# Remove archive
echo "${RED}Removing${NC} OSCAR archive.."
rm -fr "$INSTALLDIR/OSCAR.zip"

# Confirmation message
echo "${GREEN}OSCAR v$LATESTRELEASETAG has been installed!${NC}"
echo "${BLUE}Opening${NC} Finder to the application path.."
open -R "$HOME/OSCAR.app"
