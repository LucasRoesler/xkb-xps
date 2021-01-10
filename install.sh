#!/bin/bash

echo "Installing to /usr/share/X11/xkb/symbols/xps"
if [ ! -f '/usr/share/X11/xkb/symbols/xps' ]; then 
sudo ln -s `pwd`/symbols/xps /usr/share/X11/xkb/symbols/xps
fi 

echo "Updating current session"
setxkbmap xps

echo "Updating gsettings"
gsettings set org.gnome.desktop.input-sources sources "[('xkb','xps')]"

grep "setxkbmap xps" $HOME/.profile > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Adding to $HOME/.profile"
    echo "setxkbmap xps" >> $HOME/.profile
fi