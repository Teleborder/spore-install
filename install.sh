#!/bin/sh

# This is the Spore install script.
#
# Are you looking at this in your web browser, and would like to install Spore?
# Just open up your terminal and type:
#
#    curl https://install.spore.sh | sh
# 
# This script owes a debt of gratitude to the Meteor install script which it was 
# heavily inspired by.

# We wrap this whole script in a function, so that we won't execute
# until the entire script is downloaded.
# That's good because it prevents our output overlapping with curl's.
# It also means that we can't run a partially downloaded script.
run_it () {

# Error out if something goes wrong
set -e

# Let's display everything on stderr.
exec 1>&2

# This line contains the acceptance token (if there is one)
accept_token=""
accept_size=${#accept_token}

# Check that npm is installed, and fail the build if it's not
cat<<"EOF"

 -------> Checking for npm...
EOF
command -v npm >/dev/null 2>&1 || {
cat<<"EOF"
 -------> npm not found.

 -------> npm is required to install Spore.
 -------> Use one of the Node.js installers at https://node.js.org to install npm.
 -------> After installing npm, run this script again.
EOF
  exit 1
}

cat<<"EOF"
 -------> npm found.

EOF

# This always does a clean install of the latest version of Spore into
# your global npm path, which is visible when you do:
#    npm config get prefix
cat<<"EOF"
 -------> Installing Spore CLI (spore-cli)...

EOF
npm install -g git+ssh://git@github.com:Teleborder/spore-cli-node.git
if [ $? == 1 ]; then
cat<<"EOF"
 -------> CLI install failed. If you are getting an EACCESS error,
          make sure you are the owner of the npm install directory.

 -------> Take ownership by executing:
             sudo chown -R $USER $(npm config get prefix)

 -------> This is much safer than running the entire install script with `sudo`.

EOF
  exit 1
fi

cat<<"EOF"

 -------> Spore CLI installed.

EOF

# Install the daemon
cat<<"EOF"
 -------> Installing Spore Daemon (spored)...


EOF
npm install -g git+ssh://git@github.com:Teleborder/spored.git
if [ $? == 1 ]; then
cat<<"EOF"
 -------> Spore Daemon install failed.

EOF
  exit 1
fi

cat<<"EOF"

 -------> Spore Daemon installed.

EOF

if [ $(uname) != "Darwin" ]; then
cat<<"EOF"

 -------> spored needs to be running to continue.
          See how to get it started at https://github.com/Teleborder/spored
          Once it's running, Press any key to continue.

EOF
read -n 1 -s
fi

# Sign up for a Spore account
cat<<"EOF"
 -------> Creating Spore account...
          (Your action is required)

EOF
spore account:signup

if [ $? == 1 ]; then exit 1; fi

# if they have an accept token, accept it
if [ ${accept_size} != 0 ]; then
cat<<"EOF"

 -------> Accepting app invitation...

EOF
  spore accept $accept_token
fi

cat<<"EOF"

 -------> Spore is now installed!

 -------> Use `spore --help` to get started, or just `spore init` inside
          an app's root directory.

EOF

trap - EXIT
}

run_it
