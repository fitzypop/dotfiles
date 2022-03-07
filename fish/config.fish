# Pro-tip: use fish_add_path to edit the PATH variable in this config file
# DO NOT MANUALLY EDIT $PATH IN THIS FILE!!!!
# etc: fish_add_path $HOME/.cargo/bin

# Remove fish greeting
set -g fish_greeting

if status is-interactive
    #### Add custom shell variables
    set -Ux XDG_CONFIG_HOME "$HOME/.config"
    set -Ux FISH_PATH "$XDG_CONFIG_HOME/fish"
    set -Ux MYVIMRC "$XDG_CONFIG_HOME/nvim/init.vim"
    set -Ux DOTFILES "$HOME/Source/dotfiles"
    set -Ux PYTHONSTARTUP "$XDG_CONFIG_HOME/python/pythonrc"

    #### Linux specific Configs
    if test (uname) = "Linux"
        alias mongo='mongosh'
    end

    #### macOS Specific Configs
    if test (uname) = "Darwin"
        alias updatedb="sudo /usr/libexec/locate.updatedb"
        if test $TERM_PROGRAM = iTerm.app
            source "$FISH_PATH/iterm2_shell_integration.fish"
        end
    end


    #### Setup paths
    test -d "$HOME/.local/bin" && fish_add_path "$HOME/.local/bin"
    test -d "$HOME/bin" && fish_add_path "$HOME/bin"

    test -d "$HOME/.cargo" && fish_add_path "$HOME/.cargo/bin"

    if test -d /usr/local/bin; and not contains /usr/local/bin $PATH
        fish_add_path /usr/local/bin
    end

    #### Call other fish config files
    source "$FISH_PATH/abbrevs.fish"

    #### Pyenv setup
    set -Ux PYENV_ROOT "$HOME/.pyenv"
    fish_add_path "$PYENV_ROOT/bin"
    pyenv init --path | source
    pyenv init - | source

    #### Direnv Setup
    direnv hook fish | source

    #### Starship Prompt Setup
    starship init fish | source

end
