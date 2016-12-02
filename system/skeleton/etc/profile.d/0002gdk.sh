if [ ! -d $HOME/.xdg ]; then
	mkdir $HOME/.xdg
	chmod 700 $HOME/.xdg
fi

export XDG_RUNTIME_DIR=$HOME/.xdg
