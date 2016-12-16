#!/usr/bin/env bash
##########################################################################
# Install latest emacs from emacs source code
# by Aborn Jiang (aborn.jiang@gmail.com)
##########################################################################

ROOTPATH="${HOME}/github/emacs"

if [ ! -d "$ROOTPATH" ]; then
    # git clone git://git.savannah.gnu.org/emacs.git  # All history
    git clone --depth 1 git://git.sv.gnu.org/emacs.git ${ROOTPATH}
else
    cd ${ROOTPATH}
    git pull
fi
