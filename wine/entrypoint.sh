#! /usr/bin/env sh

VERSION="${VERSION:-LATEST}"

if [ ! -d "/root/.wine" ]
then
    winecfg
    xvfb-run -a winetricks -q vcrun2022
fi

export WINEDEBUG="${WINEDEBUG:--all}"

if [ ! -f "bedrock_server_mod.exe" ]; then
    if [ -n "$GITHUB_MIRROR_URL" ]; then
        lip config set github_proxies="$GITHUB_MIRROR_URL"
    fi

    if [ -n "$GO_MODULE_PROXY_URL" ]; then
        lip config set go_module_proxies="$GO_MODULE_PROXY_URL"
    fi

    if [ "$VERSION" = "LATEST" ]; then
        lip install github.com/LiteLDev/LeviLamina
    else
        lip install github.com/LiteLDev/LeviLamina@"$VERSION"
    fi

    if [ -n "$PACKAGES" ]; then
        lip install $PACKAGES
    fi
fi

if [ ! -f "run.sh" ]; then
    echo "cat | wine64 bedrock_server_mod.exe" > run.sh 
    chmod +x run.sh
fi

run.sh
