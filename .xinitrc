#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi



# load host config
HOST_CONF=".xinitrc_${HOST}"
if [ -e $HOST_CONF ]; then
	source $HOST_CONF
fi




# start some nice programs


if [ -n "`/etc/X11/chooser.sh`" ]; then
	command="`/etc/X11/chooser.sh`"
else
	failsafe="yes"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/* ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -n "$failsafe" ]; then

	export LANG="ja_JP.UTF-8"

    if which ibus-daemon >/dev/null 2>&1; then
        export XMODIFIERS="@im=ibus"
        export GTK_IM_MODULE="ibus"
        export QT_IM_MODULE="xim"
        ibus-daemon -d -x
    else
        export XMODIFIERS="@im=fcitx"
        export GTK_IM_MODULE="fcitx"
        export QT_IM_MODULE="fcitx"
        eval "$(dbus-launch --sh-syntax --exit-with-session)"
        fcitx >/dev/null 2>&1
    fi


	which start-pulseaudio-x11 >/dev/null  2>&1 && start-pulseaudio-x11
	
	exec xmonad

else
	exec $command
fi

