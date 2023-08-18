#!/bin/sh

Xephyr :5 -ac -br -noreset -screen 3360x2560 &
DISPLAY=:5
eval "$(dbus-launch --sh-syntax --exit-with-session)" # new dbus session
sleep 1 # waiting for xephyr
awesome -c empty.lua &
sleep 1 # waiting for awesome to register in dbus
awesome-client 'screen[1]:fake_resize(1440, 1480, 1920, 1080)'
awesome-client 'screen.fake_add(0, 0, 1440, 2560)'
sleep 1
awesome-client < awesome.lua # loading the config to test
