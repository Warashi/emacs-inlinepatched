#!/bin/sh
set -eu
version=$1

curl -L -O "http://ftpmirror.gnu.org/emacs/emacs-${version}.tar.xz"
tar -xf "emacs-${version}.tar.xz"
cd "emacs-${version}"

curl -L -O https://gist.githubusercontent.com/takaxp/3314a153f6d02d82ef1833638d338ecf/raw/156aaa50dc028ebb731521abaf423e751fd080de/emacs-25.2-inline.patch
patch -p1 < emacs-25.2-inline.patch

./autogen.sh
./configure --with-ns "--enable-locallisppath=/Library/Application Support/Emacs/${version}/site-lisp:/Library/Application Support/Emacs/site-lisp" --with-modules
make -j
make install
mkdir -p dist
tar -cf dist/Emacs.tar.xz -C nextstep Emacs.app