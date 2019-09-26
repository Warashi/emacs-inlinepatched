#!/bin/bash
set -euo pipefail
script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
EMACS_VERSION=${1}
OS_VERSION="$(sw_vers -productVersion | cut -f '1,2' -d '.')"

curl -L -O "http://ftpmirror.gnu.org/emacs/emacs-${EMACS_VERSION}.tar.xz"
tar -xf "emacs-${EMACS_VERSION}.tar.xz"
cd "emacs-${EMACS_VERSION}"

curl -s -L https://gist.githubusercontent.com/takaxp/3314a153f6d02d82ef1833638d338ecf/raw/156aaa50dc028ebb731521abaf423e751fd080de/emacs-25.2-inline.patch | patch -p1

./autogen.sh
./configure --with-modules --with-ns "--enable-locallisppath=/Library/Application Support/Emacs/${EMACS_VERSION}/site-lisp:/Library/Application Support/Emacs/site-lisp"
make -j
make install
$script_dir/copylib.rb ./nextstep/Emacs.app/Contents/MacOS/Emacs /usr/local nextstep/Emacs.app/Contents/MacOS/lib
cp $script_dir/launch.sh ./nextstep/Emacs.app/Contents/MacOS/Emacs.sh

mkdir -p $HOME/dmg
ln -sf /Applications $HOME/dmg/Applicatons
mv ./nextstep/Emacs.app $HOME/dmg/

mkdir -p ../dist
hdiutil create "../dist/Emacs-${EMACS_VERSION}-macOS-${OS_VERSION}.dmg" -volname "Emacs" -srcfolder $HOME/dmg
