#!/bin/sh

# This is the Spore install script. (Heavily inspired by Meteor's install script)
#
# Are you looking at this in your web browser, and would like to install Spore?
# Just open up your terminal and type:
#
#    curl https://install.spore.sh | sh

# We wrap this whole script in a function, so that we won't execute
# until the entire script is downloaded.
# That's good because it prevents our output overlapping with curl's.
# It also means that we can't run a partially downloaded script.
run_it () {

# Error out if something goes wrong
set -e

# Let's display everything on stderr.
exec 1>&2

# Get the acceptance code if there is one
accept_code=""
accept_size=${#accept_code}

# Check that npm is installed, and fail the build if it's not
printf " -------> Checking for npm... "
command -v npm >/dev/null 2>&1 || {
  cat<<"EOF"
not found.

 -------> npm is required to install Spore.
 -------> Use one of the Node.js installers at https://node.js.org to install npm.
 -------> After installing npm, run this script again.
EOF
  exit 1
}

printf "done.\n"

# This always does a clean install of the latest version of Spore into
# your global npm path, which is visible when you do:
#    npm config get prefix
printf " -------> Installing CLI...\n\n"
npm install -g git+ssh://git@github.com:Teleborder/spore-cli-node.git
if [ $? == 1 ]; then
  cat<<"EOF"
 -------> CLI install failed. If you are getting an EACCESS error,
 -------> make sure you are the owner of the npm install directory.

 -------> Take ownership by doing:
 ------->    sudo chown -R $USER $(npm config get prefix)

 -------> This is much safer than running the entire script with `sudo`.

EOF
  exit 1
fi

printf "\n"
printf " -------> CLI installed.\n\n"

# Sign up for a Spore account
printf " -------> Creating Spore account...\n\n"
spore account:signup

if [ $? == 1 ]; then exit 1; fi

# if they don't have an accept code, we're done installing
if [ ${accept_size} != 0 ]; then
  printf " -------> Accepting app invitation...\n\n"
  spore accept $accept_code
fi

cat<<"EOF"

 -------> Spore is now installed!
 -------> Use `spore --help` to get started, or just `spore init` inside
 -------> your first app root directory.

EOF

trap - EXIT
}

run_it
