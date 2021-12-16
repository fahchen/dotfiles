# Philz dotfiles

## NeoVim
```bash
ln -s $PWD/nvim ~/.config/nvim

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerInstall'
```
