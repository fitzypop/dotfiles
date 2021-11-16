nvm_for_fish_install() {
    printsl "Download and Install nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    printsl "Download and Install fisher"
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

    printsl "Install bass from fisher"
    fisher install edc/bass
}

install() {
    curr = "$DOTFILES/fish"
    dest = "${FISH_PATH:-$HOME/.config/fish}"
    mkdir -p "$dest"

    ln -sf "$curr/config.fish" "$dest/."
    ln -sf "$curr/abbrevs.fish" "$dest/."
    ln -sf "$curr/setup_tools.fish" "$dest/."
    ln -sf "$curr/completions" "$dest/."
    ln -sf "$curr/functions/nvm.fish" "$dest/functions/."

    nvm_for_fish_install
}

install
