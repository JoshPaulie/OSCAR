#!/bin/sh

########################################
#            OSCAR installer           #
# Install OSCAR to your home directory #
# Uses GitHub api to get latest bundle #
########################################

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m'

# Set install directory
INSTALLDIR="$HOME"

# Remove existing install
echo "${RED}Removing${NC} existing $INSTALLDIR/OSCAR.app, if any.."
rm -fr $INSTALLDIR/OSCAR.app

# Gather latest release details via GitHub API
LATESTRELEASEINFO=$(curl -s https://api.github.com/repos/joshpaulie/OSCAR/releases/latest)
LATESTRELEASEDOWNLOAD=$(echo "$LATESTRELEASEINFO" | grep "browser_download_url.*zip" | cut -d '"' -f 4)
LATESTRELEASETAG=$(echo "$LATESTRELEASEINFO" | grep "tag_name" | cut -d '"' -f 4)

# Install latest bundle
echo "${YELLOW}Downloading${NC} OSCAR archive to $INSTALLDIR.."
curl -sL -o $INSTALLDIR/OSCAR.zip $LATESTRELEASEDOWNLOAD

# Decompress archive
echo "${CYAN}Decompressing${NC} OSCAR archive.."
tar -xf $INSTALLDIR/OSCAR.zip --directory $INSTALLDIR

# Remove archive
echo "${RED}Removing${NC} OSCAR archive.."
rm -fr $INSTALLDIR/OSCAR.zip

# Confirmation message
echo "${GREEN}OSCAR v$LATESTRELEASETAG has been installed!${NC}"
echo "Run the app with the following command:"
echo "${BLUE}open $HOME/OSCAR.app${NC}"
