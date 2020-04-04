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
required, and fif will fall back to grep if none of those are present. I
recommend using [rg](https://github.com/BurntSushi/ripgrep) or
[ag](https://github.com/ggreer/the_silver_searcher) since those two
respect things like git ignore and hidden files. Most options passed to
these tools are configurable. More on that below.

### Preview

[bat](https://github.com/sharkdp/bat) version
[0.10.0](https://github.com/sharkdp/bat/releases/tag/v0.10.0) or above
is optionally require to syntax highlight the preview window, if bat
isn\'t present fif will fall back...

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

<details>
<summary><strong><code>FIF_ALIAS</code></strong></summary>
    Change the command name of fif via this environment variable.
    ```bash
    export FIF_ALIAS
    # re-source shell
    ```
</details>

<details>
<summary><strong><code>FIF_EDITOR_CMD</code></strong></summary>
    tmptmptmp
</details>

## Attribution

Forgit
------

Used [forgit](https://github.com/wfxr/forgit) as an example on how to do
zsh plugins and how to handle options. Also took some pointer from its
[README](https://github.com/wfxr/forgit/blob/master/README.md).
