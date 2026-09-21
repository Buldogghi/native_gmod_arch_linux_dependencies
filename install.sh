#!/usr/bin/env bash

err() {
	echo "[error] $*" >&2
}

AUR_HELPER=
if command -v paru >/dev/null; then
	AUR_HELPER="paru"
elif command -v yay >/dev/null; then
	AUR_HELPER="yay"
fi
if [ -z "$AUR_HELPER" ]; then
	err "Please install 'paru' or 'yay' to access the aur!"
	exit 1
fi

cat ./packages.txt | $AUR_HELPER -Sy - --needed --noconfirm
pushd ./lib32-gconf || exit 1
makepkg -si --needed --noconfirm
popd || exit 1

if ! [ -d ./lib32-libpng12/ ]; then
	if ! command -v git; then
		$AUR_HELPER -S git --needed --noconfirm
	fi
	git clone https://aur.archlinux.org/lib32-libpng12
fi
pushd ./lib32-libpng12 || exit 1
makepkg -si --needed --noconfirm --skippgpcheck
popd || exit 1

