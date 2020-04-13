fif: find in files
============

Quickly find text in files using fuzzy searching, and a syntax
highlighted preview with a surrounding context.

## Requirements

[fzf](https://github.com/junegunn/fzf) version
[0.18.0](https://github.com/junegunn/fzf/releases/tag/0.18.0)

## Optional

### Concatenation

For file concatenation either
[rg](https://github.com/BurntSushi/ripgrep) or
[ag](https://github.com/ggreer/the_silver_searcher) is optionally
required, and fif will fall back to `grep` if none of those are present. I
recommend using [rg](https://github.com/BurntSushi/ripgrep) or
[ag](https://github.com/ggreer/the_silver_searcher) since those two
respect things like git ignore and hidden files. Most options passed to
these tools are configurable. [More on that below](#configuration).

### Preview

[bat](https://github.com/sharkdp/bat) version
[0.10.0](https://github.com/sharkdp/bat/releases/tag/v0.10.0) or above
is optionally required to syntax highlight the preview window, if
`bat` isn't present `fif` will fall back to
[highlight](http://www.andre-simon.de/doku/highlight/highlight.php),
then [python-pygments](https://pygments.org/), and lastly `cat` with
no colors other than the highlighted line (inverted). I warmly
recommend `bat`, as its fast and does a good job highlighting

## Installation

ZSH Plugin manager
------------------

### [zplug](https://github.com/zplug/zplug)

```bash
zplug 'roosta/fif'
```

### [zgen](https://github.com/tarjoilija/zgen)

```bash
zgen load 'roosta/fif'
```

### [Antigen](https://github.com/zsh-users/antigen)

```bash
antigen bundle 'roosta/fif'
```

### Manual installation

Clone this repository somewhere and source `fif.plugin.zsh` or
`fif.plugin.sh` in your shell config.

## Demonstration

## Usage

```
fif [FILE|PATH]
```

Running `fif` with no arguments will start fuzzy matching lines in all
files from `pwd`.

fif optionally accept a path or file as an argument and will limit search to
that scope.

``` bash
fif ~/some-file.txt
```

## Configuration

### Default keybinds

  | keybind           | action                           |
  | ---------         | -------------------------------- |
  | <kbd>Enter</kbd>  | Confirm and open file location   |
  | <kbd>Ctrl-s</kbd> | Toggle sort                      |
  | <kbd>?</kbd>      | Toggle preview                   |

### Options

To use these options export environment variables and source fif.plugin.zsh

<details> <summary><strong><code>FIF_ALIAS</code></strong></summary>
Change the command name of fif via this environment variable.

```bash
export FIF_ALIAS="my-alias"
source ~/fif-location/fif.plugin.zsh
my-alias ~/file.txt
```
</details>

<details>
<summary><strong><code>FIF_EDITOR_CMD</code></strong></summary>
    tmptmptmp
</details>

<details>
<summary><strong><code>FIF_FZF_OPTS</code></strong></summary>

Environment that contains the default options when using `fzf` via
`fif`. Default is:
```
export FIF_FZF_OPTS="
--ansi
--bind='ctrl-s:toggle-sort'
--bind='?:toggle-preview'
--preview-window=up
"
```
in combination with what's defined in `FZF_DEFAULT_OPTS`. (No need to
repeat the options already defined in FZF_DEFAULT_OPTS)
</details>


<details>
<summary><strong><code>FIF_GREP_OPTS</code></strong></summary>
Environment variable storing an array of grep options. Default is:

``` bash
FIF_GREP_OPTS=(
  --color=always
  --exclude-dir={.git,.svn,CVS}
)
```
</details>

<details>
<summary><strong><code>FIF_GREP_COLORS</code></strong></summary>
Colors used with grep, default is:

``` bash
FIF_GREP_COLORS="mt=97:ln=33:fn=34:se=37"
```
This will color filenames(fn) with blue, line number(ln) as yellow,
line contents(mt) as bright white, and separators(se) as white

Check out the Environment section in the grep manual for an overview.
</details>

<details>
<summary><strong><code>FIF_RG_OPTS</code></strong></summary>
Environment variable storing an array of rg options. Defaults:

``` bash
FIF_RG_OPTS=(
  --hidden
  --color always
  --colors 'match:none'
  --colors 'path:fg:blue'
  --colors 'line:fg:yellow'
)
```
</details>

<details>
<summary><strong><code>FIF_AG_OPTS</code></strong></summary>
Environment variable storing an array of ag options. Defaults:

``` bash
FIF_AG_DEFAULT_OPTS=(
  --hidden
  --color
  --color-path 34
  --color-match 97
  --color-line-number 33
)

```

Colors used are blue for path, bright white for match, and yellow line
number

</details>

## Attribution


### [Forgit](https://github.com/wfxr/forgit)

Used as an example on how to do zsh plugins and how to handle
options. Also took some pointer from its
[README](https://github.com/wfxr/forgit/blob/master/README.md).

### [Enhancd](https://github.com/b4b4r07/enhancd)
Used for reference, and pointers
