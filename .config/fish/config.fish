# Fitypop's Fish Config

# DO NOT MANUALLY EDIT $PATH IN THIS FILE!!!!
# use `fish_add_path` instead: fish_add_path $HOME/.cargo/bin

set -g fish_greeting
set -Ux theme_nerd_fonts yes
set -gx PYTHONDONTWRITEBYTECODE 1 # prevent .pyc files
set -gx SHELL fish

# XDG variables
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

# Langs and tools setup
## rust and cargo
test -d $HOME/.cargo; and fish_add_path $HOME/.cargo/bin

## deno
if ! set -q DENO_INSTALL and test -d $HOME/.deno
    set -gx DENO_INSTALL $HOME/.deno
    fish_add_path $DENO_INSTALL/bin
end

## asdf
source ~/.asdf/asdf.fish

## pnpm
set -gx PNPM_HOME /Users/joefitzgibbons/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# pyenv
if test -d $HOME/.pyenv
    set -q PYENV_ROOT; or set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
    status is-login; and pyenv init --path | source
    status is-interactive; and pyenv init - | source
end

if status is-interactive
    # Custom variables
    set -q EDITOR; or set -gx EDITOR (which nvim)
    set -q FISH_PATH; or set -gx FISH_PATH $XDG_CONFIG_HOME/fish
    set -q MYVIMRC; or set -gx MYVIMRC $XDG_CONFIG_HOME/nvim/init.vim
    set -q DOTFILES; or set -gx DOTFILES $HOME/.dotfiles
    # set -q PYTHONSTARTUP; or set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/pythonrc
    set -l _OS (uname -s)

    # Path Setup
    test -d $HOME/.local/bin; and fish_add_path $HOME/.local/bin
    test -d $HOME/bin; and fish_add_path $HOME/bin
    test -d /usr/local/bin; and fish_add_path /usr/local/bin

    # macOS custom settings
    if test $_OS = Darwin
        alias updatedb="sudo /usr/libexec/locate.updatedb"
        # homebrew setup
        test -e /opt/homebrew/bin; or test -d /opt/homebrew/bin; and fish_add_path /opt/homebrew/bin

        # Alacritty trouble shooting
        # if test -e /usr/bin/fish; and test ! -e /usr/local/bin/fish
        #     echo 'Need to make a symlink so fish and alacritty can work together.'
        #     ln -s /usr/bin/fish /usr/local/bin/fish
        # end
    end

    # Linux custom settings
    if test $_OS = Linux
        abbr -a update 'sudo apt update && apt list --upgradable'
        abbr -a upgrade 'sudo apt upgrade -y'
        abbr -a fupdate 'flatpak update'
        abbr -a flatpak_unused 'flatpak uninstall --unused'
    end

    # Kitty custom settings
    if test $TERM = xterm-kitty
        alias ssh="kitten ssh"
    end

    # Custom Abbreviations and aliases
    abbr -a cdf 'cd $DOTFILES'
    abbr -a codf 'code $DOTFILES'

    abbr -a dev 'cd $HOME/dev/'

    # Docker
    abbr -a d docker
    abbr -a dc 'docker compose'
    abbr -a dcb 'docker compose build'
    abbr -a dcd 'docker compose down'
    abbr -a dcdr 'docker compose down --remove-orphans'
    abbr -a dcu 'docker compose up'
    abbr -a dcud 'docker compose up -d'
    abbr -a d_clean_images "docker rmi (docker images -a --filter=dangling=true -q)"
    abbr -a d_clean_ps "docker rm (docker ps --filter=status=exited --filter=status=created -q)"

    if type -q lsd >/dev/null
        abbr -a ls lsd
        abbr -a la 'lsd -lah'
        abbr -a ll 'lsd -lA --group-directories-first'
        abbr -a lt 'lsd -lA --group-directories-first --tree --depth 2'
        abbr -a lta 'lsd -la --group-directories-first --tree'
    else
        abbr -a ll 'ls -lhAF'
    end

    abbr -a install_vimplugs 'nvim -es -u init.vim -i NONE -c "PlugInstall" -c 'qa''
    type -q pnpm; and abbr -a pnpx 'pnpm dlx '
    abbr -a pre prevd # shorthand for previous directory
    abbr -a refish 'source $FISH_PATH/config.fish'

    type -q supabase; and abbr -a supa supabase

    # My virtualenv setup command, easy pyenv integration without a wrapper
    type -q virtualenv; and abbr -a nvenv 'test -d .venv; or virtualenv -p (pyenv version-name) .venv'


    # Git abbr's
    abbr -a ga 'git add'
    abbr -a gaa 'git add -A'

    abbr -a gb 'git branch -l'
    abbr -a gbr 'git branch -r'
    abbr -a gbv 'git branch -vl'

    abbr -a gcb 'git checkout -b'
    abbr -a gch 'git checkout'
    abbr -a gchm 'git checkout main'
    abbr -a gch- 'git checkout -'
    abbr -a gchpoetry 'git checkout master -- poetry.lock'

    abbr -a gcl 'git clean -fdx'

    abbr -a gcm 'git commit -m'
    abbr -a gcam 'git commit -a -m'

    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'

    # git diffs without lock files
    set _git_ignore_list "':!/*Cargo.lock' ':!/*deno.lock' ':!/*package-lock.json' ':!/*poetry.lock' ':!/*yarn.lock' ':!/*pnpm-lock.yaml' ':!/*go.sum'"
    abbr -a gdnl git diff -- $_git_ignore_list
    abbr -a gdsnl git diff --staged -- $_git_ignore_list

    abbr -a ggd 'git log --graph --oneline --decorate'

    abbr -a gl 'git pull'
    abbr -a glv 'git pull && git diff ORIG_HEAD..'

    abbr -a gp 'git push'
    abbr -a gpu 'git push -u origin HEAD'
    abbr -a gpum 'git push -u origin main'

    abbr -a gs 'git status -s'
    abbr -a gst 'git status'
    abbr -a gsl 'git status --long'

    abbr -a gwc 'git whatchanged -p --abbrev-commit --pretty=medium'

    # Github CLI shortcuts
    if type -q gh
        abbr -a gprv 'gh pr view -w'
        abbr -a grv 'gh repo view -w'

    else
        abbr -e gprv
        abbr -e grv
    end

    # Shell tools
    if type -q zoxide
        zoxide init fish | source
        alias cd z
    end

    ## Starship prompt setup
    type -q starship; and starship init fish | source
end
