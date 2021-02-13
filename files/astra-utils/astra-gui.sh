#!/usr/bin/env bash

x11vnc -create -env X11VNC_FINDDISPLAY_ALWAYS_FAILS=1 -gone 'killall Xvfb' -bg -nopw
