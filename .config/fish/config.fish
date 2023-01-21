# Fitypop's Fish Config

# DO NOT MANUALLY EDIT $PATH IN THIS FILE!!!!
# use `fish_add_path` instead: fish_add_path $HOME/.cargo/bin

set -gx PYTHONDONTWRITEBYTECODE 1 # prevent .pyc files
set -gx SHELL fish

# XDG variables
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

# Rust / Cargo
test -d $HOME/.cargo; and fish_add_path $HOME/.cargo/bin

# Deno setup
if test -d $HOME/.deno
    set -q DENO_INSTALL; or set -gx DENO_INSTALL $HOME/.deno
    fish_add_path $DENO_INSTALL/bin
end

if status is-interactive
    # Remove fish greeting
    set -g fish_greeting

    set -Ux theme_nerd_fonts yes

    # Go / g (go manager) variables
    # g-install: do NOT edit, see https://github.com/stefanmaric/g
    set -gx GOPATH $HOME/go
    set -gx GOROOT $HOME/.go
    fish_add_path $GOPATH/bin

    # Custom variables
    set -q EDITOR; or set -gx EDITOR (which nvim)
    set -q FISH_PATH; or set -gx FISH_PATH $XDG_CONFIG_HOME/fish
    set -q MYVIMRC; or set -gx MYVIMRC $XDG_CONFIG_HOME/nvim/init.vim
    set -q DOTFILES; or set -gx DOTFILES $HOME/.dotfiles
    # set -q PYTHONSTARTUP; or set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/pythonrc

    # User paths
    test -d $HOME/.local/bin; and fish_add_path $HOME/.local/bin
    test -d $HOME/bin; and fish_add_path $HOME/bin

    test -d /usr/local/bin; and fish_add_path /usr/local/bin

    # macOS Specific Configs
    if test (uname -s) = Darwin
        alias updatedb="sudo /usr/libexec/locate.updatedb"
        # homebrew setup
        test -e /opt/homebrew/bin; or test -d /opt/homebrew/bin; and fish_add_path /opt/homebrew/bin
        # iterm2 setup
        # test "$TERM_PROGRAM" = "iTerm.app"; and source $FISH_PATH/iterm2.fish

        # Alacritty trouble shooting
        # if test -e /usr/bin/fish; and test ! -e /usr/local/bin/fish
        #     echo 'Need to make a symlink so fish and alacritty can work together.'
        #     ln -s /usr/bin/fish /usr/local/bin/fish
        # end
    end

    # Set Abbreviations
    # Docker
    if type -q docker
        abbr -a d docker
        abbr -a dc docker-compose
        abbr -a dcdr 'docker-compose down --remove-orphans'
        abbr -a docker_clean_images "docker rmi (docker images -a --filter=dangling=true -q)"
        abbr -a docker_clean_ps "docker rm (docker ps --filter=status=exited --filter=status=created -q)"
    end

    # Linux Specific things
    if test (uname) = Linux
        abbr -a update 'sudo apt update && apt list --upgradable'
        abbr -a upgrade 'sudo apt upgrade -y'
        abbr -a fupdate 'flatpak update'
        abbr -a flatpak_unused 'flatpak uninstall --unused'
    end

    # Misc
    abbr -a dotfiles 'cd $DOTFILES'
    abbr -a install_vimplugs 'nvim -es -u init.vim -i NONE -c "PlugInstall" -c 'qa''
    abbr -a pre prevd # shorthand for previous directory
    abbr -a rfish 'source $FISH_PATH/config.fish'


    # My virtualenv setup command, easy pyenv integration without a wrapper
    type -q virtualenv; and abbr -a nvenv 'virtualenv -p (pyenv version-name) .venv'

    if type -q exa >/dev/null
        abbr -a ls exa
        abbr -a ll 'exa -la --icons --group-directories-first'
        abbr -a lt 'exa -la --icons --group-directories-first --tree --level=2'
    else
        abbr -a ll 'ls -lhAF'
    end

    # Git abbr's
    abbr -a ga 'git add'
    abbr -a gaa 'git add -A'

    abbr -a gb 'git branch'
    abbr -a gbl 'git branch -l'
    abbr -a gbv 'git branch -vl'

    abbr -a gcb 'git checkout -b'
    abbr -a gch 'git checkout'
    abbr -a gchpoetry 'git checkout master -- poetry.lock'

    abbr -a gcm 'git commit -m'
    abbr -a gcam 'git commit -am'

    # git diffs without lock files
    set _git_ignore_list "':!/*Cargo.lock' ':!/*deno.lock' ':!/*package-lock.json' ':!/*poetry.lock' ':!/*yarn.lock'"

    abbr -a gd 'git diff'
    abbr -a gdnl git diff -- $_git_ignore_list

    abbr -a gds 'git diff --staged'
    abbr -a gdsnl git diff --staged -- $_git_ignore_list

    abbr -a ggd 'git log --graph --oneline --decorate'

    abbr -a gl 'git pull'
    abbr -a glv 'git pull && git diff ORIG_HEAD..'

    abbr -a gp 'git push'
    abbr -a gpu 'git push -u origin'
    abbr -a gpum 'git push -u origin main'

    abbr -a gst 'git status'
    abbr -a gsl 'git status --long'
    abbr -a gss 'git status -s'

    # Github CLI shortcuts
    if type -q gh
        abbr -a gprv 'gh pr view -w'
        abbr -a grv 'gh repo view -w'
    else
        abbr -e gprv
        abbr -e grv
    end

    # Tooling / prompts

    # Pyenv setup
    if test -d $HOME/.pyenv
        set -q PYENV_ROOT; or set -gx PYENV_ROOT $HOME/.pyenv
        fish_add_path $PYENV_ROOT/bin
        status is-login; and pyenv init --path | source
        status is-interactive; and pyenv init - | source
    end

    # Starship prompt setup
    type -q starship; and starship init fish | source

    # asdf setup - WIP
    # ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    # test -d $HOME/.asdf; and source ~/.asdf/asdf.fish
end
