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

# This script is used with fzf as a preview script. Shows the file
# content around the search query match in fzf preview window using
# bat for syntax highlighting

set -euo pipefail
IFS=$'\n\t'

_fzf_preview() {
  local file linum total half_lines start end total
  match="$1"
  file=$(echo "$match" | cut -d':' -f1)
  linum=$(echo "$match" | cut -d':' -f2)
  if [ -f "$file" ]; then
    linum=$(echo "$match" | cut -d':' -f2)
    total=$(wc -l < "$file")
    half_lines=$(( FZF_PREVIEW_LINES / 2))

    # Setup beginning and end of context
    [[ $(( linum - half_lines )) -lt 1 ]] && start=1 || start=$(( linum - half_lines ))
    [[ $(( linum + half_lines )) -gt $total ]] && end=$total || end=$(( linum + half_lines ))
    [[ $start -eq 1 &&  $end -ne $total ]] && end=$FZF_PREVIEW_LINES

    bat --number \
        --color=always \
        --highlight-line "$linum" \
        --line-range "${start}:${end}" "$file"
    fi
}

main() {
  if [ "$#" != "1" ]; then
    echo "preview.sh takes exactly one argument" >&2;
    exit 1;
  else
    _fzf_preview "$@"
  fi
}

main "$@"
