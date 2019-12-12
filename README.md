# Docker container for Firefox - Tested on Debian

[Firefox](https://www.mozilla.org/en-US/firefox/) is a free and open-source web browser developed by the Mozilla Foundation.

## How to use

### Build

Container defaults UID=1000. You can override it at build stage.

```bash
docker build -t firefox --build-arg UID=$(id -u) .
```

### Simple start

```bash
docker run -it --rm \
    -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/machine-id:/etc/machine-id \
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse \
    -v $HOME/.config/pulse/cookie:/tmp/pulse_cookie \
    -v $(pwd)/extensions:/home/developer/extensions \
    --ipc=host \
    firefox
```

### About the image

Based on debian-slim, the container runs `firefox` as the user `developer` (default UID=1000).
It is pre configured with strict content blocking (see [autoconfig.cfg](autoconfig.cfg)).
If `$HOME/extensions` is found, it opens firefox with the extensions on it (see [entrypoint.sh](entrypoint.sh)).
You still have to accept them though.

### Extensions

If you would like to start the browser with extensions on it, download the xpi files and mount them on `/home/developer/extensions`.

```bash
    -v $(pwd)/extensions:/home/developer/extensions
```

#### eg. Adding uBlock

Go to the [Add-on site](https://addons.mozilla.org/es/firefox/addon/ublock-origin/).
Right click on the "+Add..." button and select "save as". Download it to `./extensions`

## Parameters explained

### X11 display

To be able to render to the host, the container needs access to the X11 socket.

```bash
    -e DISPLAY
    -v /tmp/.X11-unix:/tmp/.X11-unix
```

### Pulseaudio

To be able to send audio to the host, the container needs access to the machine_id, pulse process and pulse cookie.
The container sets PULSE_COOKIE to `/tmp/pulse_cookie`.

```bash
    -v /etc/machine-id:/etc/machine-id
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse
    -v $HOME/.config/pulse/cookie:/tmp/pulse_cookie
```

Mounting the pulse cookie at `$HOME` causes troubles with `$HOME/.config` ownership.
Either way, you can override it at runtime.
