#!/bin/bash

# Ricty Diminished for Powerlineをインストールする。

set -Cue

SOURCE_DIR="$(cd "$(dirname "$0")"; pwd)"
FONT_DIR="${HOME}/.fonts"

function download() {
    echo "スクリプトのフォルダにcloneする"
    if [ ! -d RictyDiminished-for-Powerline ] ; then
	cd "${SOURCE_DIR}"
	git clone https://github.com/mzyy94/RictyDiminished-for-Powerline.git
    else
	echo "既にcloneされているため中断。"
	exit 1
    fi
}

function move(){
    echo "fontフォルダに移動する。"
    mkdir -p "${FONT_DIR}"
    mv "${SOURCE_DIR}"/RictyDiminished-for-Powerline/powerline-fontpatched/Ricty* "${FONT_DIR}"

    echo "ゴミは削除する。"
    rm -rf "${SOURCE_DIR}"/RictyDiminished-for-Powerlin
}

function enable_font() {
    echo "fontを登録する。"
    fc-cache -f "${FONT_DIR}"

    fc-list | grep -i "Ricty"
}

download
move
enable_font
