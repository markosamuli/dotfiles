My dotfiles for OS X El Capitan
===============================

zsh
---

My default shell is Z shell.

Install [antibody](https://github.com/getantibody/antibody):

```
curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -
$HOME/.dotfiles/antibody/install.sh
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

Editors
-------

### Visual Studio Code 

Install extensions:

- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

Tools
-----

```
brew install Caskroom/cask/kaleidoscope
```

Setup iTerm
-----------

```
brew install Caskroom/cask/iterm2
```

- Install powerline fonts from the `powerlinefonts` directory
- Import themes from `iterm` directory
- Change iTerm2 font to `Meslo LG M DZ Regular for Powerline`

tmux
----

```
brew install reattach-to-user-namespace
```

Git
---

My favourite aliases are in `.gitconfig.example` with the top commands below:

- `git co` - checkout
- `git ci` - commit
- `git s` - status
- `git lg` - log with nice tree
- `git pullr` - pull with rebase
- `git wd` - word diff changes
- `git wds` - word diff staged changes

My default diff and merge tool is [Kaleidoscope](http://www.kaleidoscopeapp.com/).

License
-------

See [License](LICENSE) 
