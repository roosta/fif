#!/usr/bin/env bash

# Copyright (C) 2020 Daniel Berg <mail@roosta.sh>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# ====================================

CURRENT_DIR=$(cd "$(dirname "$(realpath "$0")")" && pwd)

FIF_FZF_DEFAULT_OPTS="
$FZF_DEFAULT_OPTS
--ansi
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--preview-window=up
--with-nth '1,3..'
"

FIF_GREP_DEFAULT_OPTS=(
  "--color=always"
  "--exclude-dir={.git,.svn,CVS}"
)

FIF_GREP_COLORS="mt=97:ln=33:fn=34:se=37"

FIF_RG_DEFAULT_OPTS=(
  --hidden
  --color always
  --colors 'match:none'
  --colors 'line:none'
  --colors 'path:fg:blue'
  --colors 'column:fg:yellow'
)

FIF_AG_DEFAULT_OPTS=(
  --hidden
  --color
  --color-path 34
  --color-match 97
  --color-line-number 33
)

# https://github.com/wfxr/forgit/blob/4eb0832e535082c36a1e07de2570d3385fb4f6fb/forgit.plugin.zsh#L2
fif::warn() { printf "%b[Warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
fif::info() { printf "%b[Info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }

fif::cat_cmd() {
  if hash rg 2>/dev/null; then
    rg "${FIF_RG_DEFAULT_OPTS[@]}" --line-number --no-heading "^" "$location"
  elif hash ag 2>/dev/null; then
    ag "${FIF_AG_DEFAULT_OPTS[@]}" --line-number --noheading "^" "$location"
  else
    GREP_COLORS=$FIF_GREP_COLORS grep "${FIF_GREP_DEFAULT_OPTS[@]}" --recursive --line-number "^" "$location"
  fi
}

fif::fzf_cmd() {
  FZF_DEFAULT_OPTS="$FIF_FZF_DEFAULT_OPTS" fzf -d "\:" --nth "2.." --preview="$CURRENT_DIR/preview.sh {}"
}

# Check if supported version of dependencies are installed, warn otherwise.
fif::check_supported() {
  local version version_only_digits supported_version supported_version_only_digits
  if hash fzf 2>/dev/null; then
    version=$(fzf --version | awk '{print $1}')
    version_only_digits=$(echo "$version" | tr -dC '[:digit:]')
    supported_version="0.18.0"
    supported_version_only_digits=$(echo "$supported_version" | tr -dC '[:digit:]')
    if [ "$version_only_digits" -lt "$supported_version_only_digits" ]; then
      fif::warn "fif: Unsupported fzf version ($version), upgrade to $supported_version or higher";
      return 1
    fi
  else
    fif::warn "fif: fzf needs to be installed for fif to work properly";
    return 1
  fi
  if hash bat 2>/dev/null; then
    version=$(bat --version)
    version_only_digits=$(echo "$version" | tr -dC '[:digit:]')
    supported_version="0.10.0"
    supported_version_only_digits=$(echo "$supported_version" | tr -dC '[:digit:]')
    if [ "$version_only_digits" -lt "$supported_version_only_digits" ]; then
      fif::warn "fif: Unsupported bat version ($version), upgrade to $supported_version or higher";
      return 1
    fi
  else
    fif::warn "fif: bat needs to be installed for preview.sh to work";
    return 1
  fi
}

fif::find_in_files() {
  local location
  fif::check_supported || return 1
  if [ -d "$1" ] || [ -f "$1" ]; then
    location="$1"
  else
    location="."
  fi
  match=$(fif::cat_cmd "$location" | fif::fzf_cmd) &&
    linum=$(echo "$match" | cut -d':' -f2) &&
    file=$(echo "$match" | cut -d':' -f1) &&
    eval "${EDITOR:-vim}" "+${linum}" "$file"

}

# shellcheck disable=SC2139
alias "${fif_alias:-fif}"='fif::find_in_files'
