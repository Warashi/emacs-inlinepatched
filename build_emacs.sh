#!/bin/sh
set -eu
script_dir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
version=$1
os=$2

curl -L -O "http://ftpmirror.gnu.org/emacs/emacs-${version}.tar.xz"
tar -xf "emacs-${version}.tar.xz"
cd "emacs-${version}"

curl -s -L https://gist.githubusercontent.com/takaxp/3314a153f6d02d82ef1833638d338ecf/raw/156aaa50dc028ebb731521abaf423e751fd080de/emacs-25.2-inline.patch | patch -p1

./autogen.sh
./configure --with-modules --with-ns "--enable-locallisppath=/Library/Application Support/Emacs/${version}/site-lisp:/Library/Application Support/Emacs/site-lisp"
make -j
make install
$script_dir/copylib.rb ./nextstep/Emacs.app/Contents/MacOS/Emacs /usr/local nextstep/Emacs.app/Contents/MacOS/lib
cp $script_dir/launch.sh ./nextstep/Emacs.app/Contents/MacOS/Emacs.sh

mkdir -p $HOME/dmg
ln -sf /Applications $HOME/dmg/Applicatons
mv ./nextstep/Emacs.app $HOME/dmg/

mkdir -p ../dist
hdiutil create ../dist/Emacs-$version-$os.dmg -volname "Emacs" -srcfolder $HOME/dmg
