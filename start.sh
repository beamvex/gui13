#!/bin/bash

# Start VNC server
export VNC_PASSWORD=vncpassword
mkdir -p ~/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd
vncserver :1 -geometry 1024x768 -depth 24  &

# Wait for VNC to start
sleep 2

echo -e "\n------------------ startup of Xfce4 window manager ------------------"

### disable screensaver and power management
xset -dpms &
xset s noblank &
xset s off &

/usr/bin/startxfce4 --replace > $HOME/wm.log &
sleep 1
cat $HOME/wm.log

# Keep the container running
tail -f /dev/null