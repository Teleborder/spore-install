#!/bin/sh

# This is the Spore uninstall script.
#
# Are you looking at this in your web browser, and would like to uninstall Spore?
# Just open up your terminal and type:
#
#    curl https://install.spore.sh/uninstall | sh
# 
# This script owes a debt of gratitude to the Meteor and Pow install scripts,
# which it was heavily inspired by.

# We wrap this whole script in a function, so that we won't execute
# until the entire script is downloaded.
# That's good because it prevents our output overlapping with curl's.
# It also means that we can't run a partially downloaded script.
run_it () {

# Error out if something goes wrong
set -e

# Let's display everything on stderr.
exec 1>&2

# Check that npm is installed, and fail the build if it's not
cat<<EOF

 -------> Checking for npm...
EOF
command -v npm >/dev/null 2>&1 || {
cat<<EOF
 -------> npm not found.

 -------> npm is required to uninstall Spore.
 -------> Use one of the Node.js installers at https://node.js.org to install npm.
 -------> After installing npm, run this script again.
EOF
  exit 1
}

cat<<EOF
 -------> npm found.

EOF

cat<<EOF
 -------> Uninstalling Spore CLI (spore-cli)...

EOF
npm uninstall -g spore-cli
if [ $? == 1 ]; then
cat<<"EOF"
 -------> CLI uninstall failed. If you are getting an EACCESS error,
          make sure you are the owner of the npm install directory.

 -------> Take ownership by executing:
             sudo chown -R $USER $(npm config get prefix)

 -------> This is much safer than running the entire uninstall script with `sudo`.

EOF
  exit 1
fi

cat<<EOF

 -------> Spore CLI uninstalled.

EOF

# Uninstall the daemon
cat<<EOF
 -------> Uninstalling Spore Daemon (spored)...


EOF
npm uninstall -g spored
if [ $? == 1 ]; then
cat<<EOF

 -------> Spore Daemon uninstall failed.

EOF
  exit 1
fi

cat<<EOF

 -------> Spore Daemon uninstalled.

EOF

cat<<EOF

 -------> Spore has been uninstalled.

 -------> We're sorry to see you go!

EOF

trap - EXIT
}

run_it
