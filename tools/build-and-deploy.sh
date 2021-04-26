#!/bin/sh

# set -e

which butler

echo "Checking application versions..."
echo "-----------------------------"
cat ~/.local/share/godot/templates/3.3.stable/version.txt
godot --version
butler -V
echo "-----------------------------"

mkdir build/
mkdir build/linux/
mkdir build/osx/
mkdir build/win/

echo "EXPORTING FOR LINUX"
echo "-----------------------------"
godot --export "Linux/X11" build/linux/ld48.x86_64 -v
echo "EXPORTING FOR OSX"
echo "-----------------------------"
godot --export "Mac OSX" build/osx/ld48.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export "Windows Desktop" build/win/ld48.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv ld48.dmg ld48-osx-alpha.zip
# unzip ld48-osx-alpha.zip
# rm ld48-osx-alpha.zip
# chmod +x ld48.app/Contents/MacOS/ld48
# zip -r ld48-osx-alpha.zip ld48.app
# rm -rf ld48.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r ld48-win-alpha.zip ld48.exe ld48.pck
rm -r ld48.exe ld48.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r ld48-linux-alpha.zip ld48.x86_64 ld48.pck
rm -r ld48.x86_64 ld48.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/ld48:linux-alpha
butler push build/osx/ synsugarstudio/ld48:osx-alpha
butler push build/win/ synsugarstudio/ld48:win-alpha
