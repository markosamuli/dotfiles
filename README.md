My dotfiles for OS X El Capitan
===============================

Install
-------

```
git clone https://github.com/markosamuli/dotfiles.git ~/.dotfiles
```

zsh
---

My default shell is Z shell.

Install [antibody](https://github.com/getantibody/antibody):

```
curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -
$HOME/.dotfiles/antibody/install.sh
```

Symlink `.zshrc` to your home directory:

```
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```

bash
----

The `.bashrc` contains just few bits for compatibility.

```
ln -s ~/.dotfiles/.bashrc ~/.bashrc
```

Aliases
-------

Custom aliases and functions are in `.aliases`.

Machine Setup
-------------

Download my machine setup Ansible playbooks:

```
wget https://github.com/markosamuli/machine/archive/master.zip
unzip machine-master.zip
cd machine-master
```

Or using Git:

```
git clone git@github.com:markosamuli/machine.git
cd machine
```

Modify `main.yml` file to your requirements and run the setup script.

```
./setup
```

EditorConfig
------------

Symlink [EditorConfig](http://editorconfig.org/) file:

```
ln -s ~/.dotfiles/.editorconfig ~/.editorconfig
```

Install extensions:

- Visual Studio Code [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

The `.editorconfig` file should meet [Google Style Guides](https://github.com/google/styleguide).

Kaleidoscope
------------

I'm using [Kaleidoscope](http://www.kaleidoscopeapp.com/) as my default diff/merge tool on Mac.

```
brew install Caskroom/cask/kaleidoscope
```

Setup iTerm
-----------

I'm using [iTerm2](https://www.iterm2.com/) as my default terminal on Mac.

```
brew install Caskroom/cask/iterm2
```

- Install powerline fonts from the `powerlinefonts` directory
- Import [Solarized](https://github.com/altercation/solarized) themes from `iterm` directory
- Change iTerm2 font to `Meslo LG M DZ Regular for Powerline`

tmux
----

```
brew install reattach-to-user-namespace
```

Git
---

Copy [.gitconfig.example](.gitconfig.example) file for my aliases and few defaults:

```
cp ~/.dotfiles/.gitconfig.example ~/.gitconfig
```

See [.gitconfig.govuskuolfi](.gitconfig.govuskuolfi) for my OS X specific tools configuration.

```
ln ~/.dotfiles/.git_template ~/.git_template
ln ~/.dotfiles/.gitchangelog.rc ~/.gitchangelog.rc
ln ~/.dotfiles/.gitignore_global ~/.gitignore_global
```

My favourite aliases:

- `git co` - checkout
- `git ci` - commit
- `git s` - status
- `git lg` - log with nice tree
- `git pullr` - pull with rebase
- `git wd` - word diff changes
- `git wds` - word diff staged changes

License
-------

See [License](LICENSE) 
