# My dotfiles

## Install

```bash
curl -s https://raw.githubusercontent.com/markosamuli/dotfiles/master/install.sh | bash -
```

The installer clones this repository to `~/.dotfiles` if it is not there yet,
then:

- installs Homebrew (macOS only), zsh, [Sheldon](https://sheldon.cli.rs/),
  Vim and the GitHub CLI where they are missing. Run from a terminal, it asks
  before each of them except Vim; piped as above, it does not ask;
- links `.zshrc`, `.zshenv`, `.zprofile`, `.bashrc`, `.profile`, `.aliases`,
  `.vimrc`, `.editorconfig`, `.markdownlintrc` and `.gitignore_global` into
  `~`, backing up any existing file;
- links the Sheldon plugin list to `~/.config/sheldon/plugins.toml`;
- configures Git to include this repository's [`.gitconfig`](.gitconfig) and
  use `.gitignore_global`, unless your global Git configuration already sets
  an `include.path` or an excludes file.

It makes zsh your login shell only when run from a terminal. When piped, it
prints the commands to finish that step:

```bash
cd ~/.dotfiles
make install
```

## Aliases

Custom aliases and functions are in `.aliases`.

## Git

The installer adds [`.gitconfig`](.gitconfig) to your global Git
configuration with `include.path` (unless one is already set), so its aliases
and defaults apply without copying anything. Settings for one machine only
belong in `~/.gitconfig` itself, which takes precedence.

My favourite aliases:

- `git co` - checkout
- `git ci` - commit
- `git s` - status
- `git lg` - log with nice tree
- `git pullr` - pull with rebase
- `git wd` - word diff changes
- `git wds` - word diff staged changes

## AI Usage

Parts of this repository are written with AI assistance. Everything here is
reviewed, tested on my own machines, and mine to maintain. Agent-assisted
commits are marked in the git history; see [AGENTS.md](AGENTS.md).

## License

See [License](LICENSE)

## Author

[@markosamuli](https://github.com/markosamuli)
