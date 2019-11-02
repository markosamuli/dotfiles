# My dotfiles

## Install

```bash
curl -s https://raw.githubusercontent.com/markosamuli/dotfiles/master/install.sh | bash -
```

- Install and configure zsh as default shell.
- Install [antibody](https://github.com/getantibody/antibody)
- Create symlinks in `~/.zshrc` and `~/.bashrc`
- Create [EditorConfig](http://editorconfig.org/) symlink in `~/.editorconfig`

## Aliases

Custom aliases and functions are in `.aliases`.

## Machine Setup

Read my [Machine Setup Guide](https://machine.msk.io/) that explains
development environment set up using my playbooks.

## Visual Studio Code

Install [markosamuli.vscode-essentials] extension pack with common extensions I use daily.

```bash
code --install-extension markosamuli.vscode-essentials
```

[markosamuli.vscode-essentials]: https://marketplace.visualstudio.com/items?itemName=markosamuli.vscode-essentials

## Kaleidoscope

I'm using [Kaleidoscope](http://www.kaleidoscopeapp.com/) as my default diff/merge tool on Mac.

```bash
brew cask install kaleidoscope
```

## Setup iTerm

I'm using [iTerm2](https://www.iterm2.com/) as my default terminal on Mac.

```bash
brew cask install iterm2
```

## tmux

```bash
brew install reattach-to-user-namespace
```

## Git

Copy [.gitconfig.example](.gitconfig.example) file for my aliases and few defaults:

```bash
cp ~/.dotfiles/.gitconfig.example ~/.gitconfig
```

See [.gitconfig.govuskuolfi](.gitconfig.govuskuolfi) for my OS X specific tools configuration.

```bash
ln ~/.dotfiles/.gitchangelog.rc ~/.gitchangelog.rc
```

My favourite aliases:

- `git co` - checkout
- `git ci` - commit
- `git s` - status
- `git lg` - log with nice tree
- `git pullr` - pull with rebase
- `git wd` - word diff changes
- `git wds` - word diff staged changes

## License

See [License](LICENSE)

## Author

[@markosamuli](https://github.com/markosamuli)
