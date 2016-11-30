[ -d /run/xdg ] ||
	mkdir /run/xdg && chmod 700 /run/xdg

export XDG_RUNTIME_DIR=/run/xdg
