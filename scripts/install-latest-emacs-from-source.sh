#!/usr/bin/env bash
##########################################################################
# Install latest emacs from emacs source code
# by Aborn Jiang (aborn.jiang@gmail.com)
# for mac builds: https://emacsformacosx.com/builds
# I did this in mac.
#   1. brew install gnutls
##########################################################################

ROOTPATH="${HOME}/github/emacs"

# clone source code first
if [ ! -d "$ROOTPATH" ]; then
    # git clone git://git.savannah.gnu.org/emacs.git  # All history
    git clone --depth 1 git://git.sv.gnu.org/emacs.git ${ROOTPATH}
else
    cd ${ROOTPATH}
    git pull
fi

# configure & compile & install
cd ${ROOTPATH}
./autogen.sh
./configure
make
make install
