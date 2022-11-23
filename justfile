brewfile:
	brew bundle dump -f --no-lock --file ${DOTFILES}/Brewfile

brewinstall:
	brew bundle install --no-lock --file ${DOTFILES}/Brewfile

root_dir := justfile_directory()

save-vsc-ext:
	code --list-extensions > {{root_dir}}/vscode.extensions

vsc-ext:
	cat {{root_dir}}/vscode.extensions | xargs -L 1 echo code --install-extensions
