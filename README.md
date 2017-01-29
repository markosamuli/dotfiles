My dotfiles for OS X El Capitan
===============================

zsh
---

My default shell is Z shell.

My `.zshrc` uses [antigen](https://github.com/zsh-users/antigen) plugin manager.

My default theme is [powerlevel9k](https://github.com/bhilburn/powerlevel9k) with Powerline prompt.

### Install antibody

https://github.com/getantibody/antibody

    curl -s https://raw.githubusercontent.com/getantibody/installer/master/install | bash -
    echo 'source <(antibody init)' >> ~/.zshrc
    antibody


Aliases
-------

Custom aliases and functions are in `.aliases`.

Setup iTerm
-----------

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

My favourite aliases are in my `.gitconfig` with the top commands below:

- `git co` - checkout
- `git ci` - commit
- `git s` - status
- `git lg` - log with nice tree
- `git pullr` - pull with rebase
- `git wd` - word diff changes
- `git wds` - word diff staged changes

My default diff and merge tool is [Kaleidoscope](http://www.kaleidoscopeapp.com/).
