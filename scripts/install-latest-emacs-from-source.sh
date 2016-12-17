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

# mac 通过brew方式安装最新的emacs版本
# 参考：http://emacsredux.com/blog/2015/05/09/emacs-on-os-x/
brew install emacs --HEAD --with-cocoa   ## 总是安装最新的
# 源码clone到/Users/aborn/Library/Caches/Homebrew/emacs--git
# 安装成功后的目录为： /usr/local/Cellar/emacs
# ./autogen.sh
# 配置为 ./configure --disable-silent-rules --enable-locallisppath=/usr/local/share/emacs/site-lisp --infodir=/usr/local/Cellar/e
# make & make install
