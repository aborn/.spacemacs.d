#!/usr/bin/env bash
##########################################################################
# install emacs 25 automatically.
# by Aborn Jiang (aborn.jiang@gmail.com)
##########################################################################

# ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-25.0.95.tar.xz
wget ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-25.1-rc1.tar.xz

# unzip
xz -d emacs-25.0.95.tar.xz
tar -xvf emacs-25.0.95.tar

cd emacs-25.0.95/
# install depends
sudo apt-get install libgtk-3-dev #first
# configure: error: xwidgets requested but WebKitGTK+ not found
sudo apt-get install libwebkitgtk-dev
sudo apt-get install libwebkitgtk-3.0-dev

./configure --with-xwidgets  --with-x-toolkit=gtk3
make
sudo make install

# open emacs
# M-x xwidget-webkit-browse-url
