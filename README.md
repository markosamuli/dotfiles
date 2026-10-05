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

## What could go wrong

`install.sh` changes the machine, not only `~/.dotfiles`. Read it before
running it, and do not pipe it to `bash` on a machine you cannot repair.
This section lists the risks, not every step; the script is the inventory.

- **Your dotfiles are moved aside.** A real `~/.zshrc`, `~/.bashrc` or similar
  file is renamed to `~/.<name>.<timestamp>` and replaced with a symlink. An
  existing symlink is left alone, even if it points somewhere else, and the
  installer does not warn you.
- **It runs remote installers and asks for `sudo`.** Homebrew is installed with
  its own `curl | bash` installer, and on Linux so is Sheldon. On Debian and
  Ubuntu it uses `sudo apt`, adds the GitHub CLI package repository and its
  signing key, and may create a man page directory with `sudo`. Piped as
  above, it installs all of this without asking, and Vim is never asked about.
- **It can change your login shell.** When zsh comes from Homebrew, it may
  append that path to `/etc/shells` with `sudo`. Run from a terminal, it also
  runs `chsh` to make zsh your login shell.
- **It edits your global Git configuration.** It sets some values only when
  they are unset, and others every time it runs, so a value you set yourself
  can be overwritten. Check `git config --global --list` afterwards.
- **It changes file permissions recursively.** It removes group and other
  access from `~/.dotfiles`, `~/.ssh` and the Homebrew cache, and removes group
  and other write access from the shared zsh directory under `/usr/local`. Do
  not run it if something else relies on that access.
- **Tools that edit your shell files edit this repository.** After installing,
  `~/.zshrc` and the other entry points are symlinks into the checkout, so an
  installer that appends to one, bun's for example, creates an uncommitted
  change here. Restore the file and add the setup as a module instead. The
  `shell-config` pre-commit hook stops absolute home paths from being
  committed.

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
