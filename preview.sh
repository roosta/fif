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

fif::highlight_line() {
  local content linum
  content="$1"
  linum="$2"
  hl=$(awk -v linum="$linum" '{if (NR==linum) {print "\033[7m" $0 "\033[0m"} else {print $0}}' <<< "$content")
  echo "$hl"
}

fif::basic_hl() {
  local file linum context hl
  file="$1"
  linum="$2"
  content=$(cat "$file")
  hl=$(fif::highlight_line "$content" "$linum")
  context=$(sed -n "${start},${end}p" <<< "$hl")
  echo "$context"
}

fif::pygmentize() {
  local file linum context hl start end
  file="$1"
  linum="$2"
  start="$3"
  end="$4"
  color=$(pygmentize -g "$file")
  hl=$(fif::highlight_line "$color" "$linum")
  context=$(sed -n "${start},${end}p" <<< "$hl")
  echo "$context"
}

fif::highlight() {
  local file linum context hl start end
  file="$1"
  linum="$2"
  start="$3"
  end="$4"
  color=$(highlight \
    --out-format=ansi \
    --line-range="${start}-${end}" \
    --force \
    "$file")
  echo "$color"
}

fif::bat() {
  local file linum start end
  file="$1"
  linum="$2"
  start="$3"
  end="$4"
  color=$(bat \
    --number \
    --color=always \
    --highlight-line "$linum" \
    --line-range "${start}:${end}" "$file")
  echo "$color"
}

fif::preview() {
  local file linum total half_lines start end total out query
  query="$1"
  match="$2"
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

    if hash bat 2>/dev/null; then
      out=$(fif::bat "$file" "$linum" "$start" "$end")
    elif hash highlight 2>/dev/null; then
      out=$(fif::highlight "$file" "$linum" "$start" "$end")
    elif hash pygmentize 2>/dev/null; then
      out=$(fif::pygmentize "$file" "$linum" "$start" "$end")
    else
      out=$(fif::basic_hl "$file" "$linum")
    fi
    echo "$out"
  fi
}

main() {
  if [ "$#" != "2" ]; then
    echo "preview.sh takes exactly two arguments" >&2;
    exit 1;
  else
    fif::preview "$@"
  fi
}

main "$@"
