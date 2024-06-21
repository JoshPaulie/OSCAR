# OSCAR installer

# Set install directory
INSTALLDIR="$HOME"

# Confirmation prompt
read -p "Are you sure you'd like to install OSCAR to your home directory? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
	echo 'Sounds good! You can download the app bundle from the repo: https://github.com/joshpaulie/OSCAR'
	exit 1
fi

# Remove existing install
echo "Removing existing $INSTALLDIR/OSCAR.app, if any.."
rm -fr $INSTALLDIR/OSCAR.app

# Install latest bundle
echo "Downloading OSCAR archive to $INSTALLDIR.."
curl -sL -o $INSTALLDIR/OSCAR.zip \
	$(curl -s https://api.github.com/repos/joshpaulie/OSCAR/releases/latest \
	| grep "browser_download_url.*zip" \
	| cut -d '"' -f 4)

# Decompress archive
echo "Decompressing OSCAR archive.."
tar -xf $INSTALLDIR/OSCAR.zip --directory $INSTALLDIR

# Remove archive
echo "Removing OSCAR archive.."
rm -fr $INSTALLDIR/OSCAR.zip

# Confirmation message
echo "OSCAR has been installed!"

# Offer to open
read -p "Would you like to start OSCAR? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    open $INSTALLDIR/OSCAR.app
fi
