#!/bin/sh
# Description: Destroy the vault's persistent storage and reset the pki
# vim: ft=sh ts=4 sw=4 sts=4 noet
set -euf

# shellcheck disable=SC1091
. ./lib/dab.sh

dab services destroy consul vault || true
dab config set pki/vault/init