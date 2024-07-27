# Fitzypop's Dotfiles and config files

My various config files, fonts, icons, and other things I need across systems.

![Terminal Image](/assets/terminal.png "My terminal image")

My setup and tools:

- Terminal: [Kitty](https://github.com/kovidgoyal/kitty), previously [Alacritty](https://github.com/alacritty/alacritty)
- Prompt: [Starship](https://starship.rs/)
- Shell: [Fish](https://fishshell.com/)
- Text Editors: [VS Code](https://code.visualstudio.com/) and [Neovim](https://github.com/neovim/neovim)
- Fonts: [Nerd Fonts](https://www.nerdfonts.com/) (FiraCode and Hack)
- Dotfiles Management: [GNU Stow](https://www.gnu.org/software/stow/)

## Branches

You must switch branch for your respective OS.

`main` is for Linux and MacOS, mainly Pop!_OS/Ubuntu/macOS. Anything with apt or homebrew.

`windows` is for windows.

## Installation

Clone this repo and run these commands to create my dev workflow. My recommendation is clone this repo into `$HOME/.dotfiles` like this

```git clone <this repo> .dotfiles```

```shell
#linux
apt install -y stow

cd $HOME/.dotfiles
stow .
```

```sh
# macOS Specific installation

# install xcode cli tools: need git installed
xcode-select --install

# clone repo to dotfiles dir
git clone git@github.com:joefitzy/dotfiles.git $HOME/.dotfiles

# Move into dotfiles dir
cd $HOME/.dotfiles

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install packages from brewfile
brew update && brew install just
just brewinstall

# install virtualenv
pipx install virtualenv

# use gnu stow to manage symlinks for dotfiles
# must be in $HOME/.dotfiles directory
stow .

# change shell to fish
# For mac, add fish path to `/etc/shells` file.
chsh -s $(which fish)
```

## Troubleshooting

### Alacritty

You might need to make a symlink to your fish install like this:

```sh
ln -s <current_fish_locaation> /usr/local/bin/fish
```

### N

If you want to avoid using sudo with `n` all the time: run these commands in your shell.

```sh
# make cache folder (if missing) and take ownership
sudo mkdir -p /usr/local/n
sudo chown -R $(whoami) /usr/local/n
# make sure the required folders exist (safe to execute even if they already exist)
sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# take ownership of Node.js install destination folders
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
```

## ASDF

Let's try out asdf

<https://asdf-vm.com/guide/getting-started.html/>

```sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# add to fish/config.fish
source ~/.asdf/asdf.fish
# close file

# fish shell completions
mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

# add nodejs plugin
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# install a version
asdf install nodejs latest
```
