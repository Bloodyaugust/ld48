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
godot --export "Linux/X11" build/linux/dwarvelings.x86_64 -v
# echo "EXPORTING FOR OSX"
# echo "-----------------------------"
# godot --export "Mac OSX" build/osx/dwarvelings.dmg -v
echo "EXPORTING FOR WINDOZE"
echo "-----------------------------"
godot --export "Windows Desktop" build/win/dwarvelings.exe -v
echo "-----------------------------"

# echo "CHANGING FILETYPE AND CHMOD EXECUTABLE FOR OSX"
# echo "-----------------------------"
# cd build/osx/
# mv dwarvelings.dmg dwarvelings-osx-alpha.zip
# unzip dwarvelings-osx-alpha.zip
# rm dwarvelings-osx-alpha.zip
# chmod +x dwarvelings.app/Contents/MacOS/dwarvelings
# zip -r dwarvelings-osx-alpha.zip dwarvelings.app
# rm -rf dwarvelings.app
# cd ../../

ls -al
ls -al build/
ls -al build/linux/
ls -al build/osx/
ls -al build/win/

echo "ZIPPING FOR WINDOZE"
echo "-----------------------------"
cd build/win/
zip -r dwarvelings-win-alpha.zip dwarvelings.exe dwarvelings.pck
rm -r dwarvelings.exe dwarvelings.pck
cd ../../

echo "ZIPPING FOR LINUX"
echo "-----------------------------"
cd build/linux/
zip -r dwarvelings-linux-alpha.zip dwarvelings.x86_64 dwarvelings.pck
rm -r dwarvelings.x86_64 dwarvelings.pck
cd ../../

echo "Logging in to Butler"
echo "-----------------------------"
butler login

echo "Pushing builds with Butler"
echo "-----------------------------"
butler push build/linux/ synsugarstudio/ld48:linux-alpha
# butler push build/osx/ synsugarstudio/ld48:osx-alpha
butler push build/win/ synsugarstudio/ld48:win-alpha
