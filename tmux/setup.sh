#!/bin/bash

set -ue

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

SRC_DIR="${HOME}/local/src"
LOCAL_DIR="${HOME}/local"

SERIAL="$(date +%Y%m%d%H%M%S)"

TMUX_VERSION="3.1b"

function download(){
    echo "依存パッケージをインストールする。"
    sudo apt install -y build-essential \
                        libncurses5-dev \
			libevent-dev

    echo "ソースをダンロードして、展開する。"
    mkdir -p "${SRC_DIR}"
    cd "${SRC_DIR}"
    curl -OL \
         "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
    tar -zxvf "tmux-${TMUX_VERSION}.tar.gz"
}

function install(){
    echo "コンパイル、インストールする。"
    cd "./tmux-${TMUX_VERSION}"
    ./configure --prefix="${LOCAL_DIR}"
    make
    make install
}

function config(){
    echo "既存のコンフィグをバックアップする。"
    if [ -f "${HOME}/.tmux.conf" ]; then
        mv "${HOME}/.tmux.conf" "${HOME}/.tmux.conf.${SERIAL}"
    fi

    echo "コンフィグをコピーする。"
    cd "${SCRIPT_DIR}"
    cp -i ./.tmux.conf "${HOME}/"
}

function env(){
    echo "${HOME}/local/bin にパスを通す。"
    cat <<EOF >> "${HOME}/.bashrc"

# tmux
PATH="\${HOME}/local/bin:\${PATH}"
EOF

}

download
install
config
env

