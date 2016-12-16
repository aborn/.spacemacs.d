#!/usr/bin/env bash
##########################################################################
# Install latest emacs from emacs source code
# by Aborn Jiang (aborn.jiang@gmail.com)
##########################################################################

ROOTPATH="~/github/emacs"
git clone --depth 1 git://git.sv.gnu.org/emacs.git ${ROOTPATH}
