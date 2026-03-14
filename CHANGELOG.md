# Change log


## [v0.4]
- Fix issue with source order and setting custom opts arrays, now correctly
  sources user config before using the defaults
- Fix issue with bash word-splitting, setting the environment variable using
  word-splitting now works in bash as well

## [v0.3]

- Fix broken escape sequences when searching some directories
    - Fix issue trying to traverse broken links would break the terminal ANSI
    - Remove `eval` calls as those also made it difficult to debug, and caused odd issues when fixing the above issue
- Fix issue opening a line when passing a file to `fif`
- Fix issue where opening a line with a newline literal would break the
  argument parsing when calling editor script

### Breaking change

BREAKING:
- Environment variables with embedded spaces need to be changed to the
  array option, else fif now only splits on whitespace.

  You can still use the environment variables, but it no longer supports
  splitting on anything but spaces. If you need more control there is
  now a few new options that can be set before sourcing the plugin:

- fif_grep_opts
- fif_rg_opts
- fif_grep_opts

See readme for details on each

## [v0.2]

### Breaking change

I've had to change how `grep`/`ag`/`rg` opts are handled due to bash not allowing for
array export. The new syntax is as follows:

```bash
# Single line
export FIF_RG_OPTS="--hidden --color always --colors=match:none --colors=path:fg:blue --colors=line:fg:yellow --follow"

# Multiline
export FIF_RG_OPTS="\
  --hidden \
  --color always \
  --colors=match:none \
  --colors=path:fg:blue \
  --colors=line:fg:yellow \
  --follow \
  "
```
Gotta be careful with the newline chars, it'll trip up `fif` if the backslash isn't included.


### Fixed

- Now highlights line when using pygmentize and cat for preview
- Fix issues when using custom editor script
- Follow symlinks by default
- Minor tweaks and readme updates
- Prevent exit when bat isn't present. Fall back to alternatives.

### Changed

- Change keybinding for toggling preview <kbd>Ctrl-p</kbd>
- Add customization option for editor.sh `$FIF_EDITOR_SCRIPT`

[v0.2]: https://github.com/roosta/fif/compare/v0.1...v0.2
[v0.3]: https://github.com/roosta/fif/compare/v0.2...v0.3
[v0.4]: https://github.com/roosta/fif/compare/v0.3...v0.4
