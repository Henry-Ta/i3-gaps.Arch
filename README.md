# i3-gaps.Arch

## Active wifi from Network Manager

```
$ nmtui
$ sudo pacman -Syy
```

## Install packages

```
$ sudo pacman -S (xf86-video-intel/xf86-video-amdgpu) (nvidia-lts/nvidia nvidia-utils nvidia-settings) xorg-server xfce4 xfce4-goodies
( $ sudo pacman -S i3-gaps i3blocks rofi nitrogen lxappearance ranger )

$ sudo pacman -S kitty qutebrowser firefox chromium vlc gimp file-roller pavucontrol lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings evince galculator neofetch gufw clamtk libreoffice-fresh exa tmux bpytop bleachbit

(pcmanfm gpicview nnn picom geany geany-plugins)
```

## Prepare for start up

```
$ cp /etc/X11/xinit/xinitrc .xinitrc
$ nvim .xinitrc

exec i3
```

```
$ sudo systemctl enable lightdm ( if we use lightdm, otherwise "gdm" - GNOME, "sddm" - KDE )
```

## Post Installation

#### i3 config

```
$ nvim ~/.config/i3/config

( Update rofi, kitty )
```

#### Fonts

```
$ sudo pacman -S otf-font-awesome otf-cascadia-code ttf-fira-code ttf-droid ttf-joypixels ttf-nerd-fonts-symbols ttf-ionicons
```

#### Install wifi for Kernel module

```
* Install

$ git clone https://github.com/lwfinger/rtw88.git
$ cd rtw88
$ make
$ sudo make install


* Disable/enable a kernel module

$ sudo modprobe -r rtw_8723de         #This unloads the module
$ sudo modprobe rtw_8723de            #This loads the module

* When kenel changes, have to update
$ cd ~/rtw88
$ git pull
$ make
$ sudo make install
```

#### Neovim plug manager

```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

#### Install Yay

```
$ cd /opt
$ sudo git clone https://aur.archlinux.org/yay.git
$ sudo chown -R henry:users ./yay
$ cd yay
$ makepkg -si
```

#### Install AUR packages

```
$ yay -S pamac-aur zoom visual-studio-code-bin ttf-iosevka ttf-icomoon-feather ttf-font-icons gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git optimus-manager optimus-manager-qt picom-ibhagwan-git

( $ yay -S heroku-cli polybar gotop )

( $ sudo systemctl enable optimus-manager )
( $ sudo systemctl start optimus-manager )
```

#### Install Python packages

```
$ sudo pacman -S python-pygame python-requests python-pandas python-beautifulsoup4

($ sudo pacman -S python-pylint python-openpyxl )
```

#### Install Steam

```
$ sudo nvim /etc/pacman.conf
[multilib]
Include = /etc/pacman.d/mirrorlist

$ sudo pacman -S wqy-zenhei steam
Choose Nvidia vulcan (2)
```

#### Install zsh

```
$ sudo pacman -S zsh zsh-completions zsh-syntax-highlighting

(Set zsh default shell)
$ chsh -s $(which zsh)

(oh-my-zsh)
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

(powerlevel10)
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

nvim ~/.zshrc
$ ZSH_THEME="powerlevel10k/powerlevel10k"

(zsh-autosuggestions)
$ git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

(zsh-syntax-highlighting)
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

$ nvim ~/.zshrc
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

```

## App configures

#### Neovim

```
$ sudo pacman -S clang nodejs npm ctags the_silver_searcher gopls
```

#### Ranger

```
$ sudo pacman -S bat ueberzug elinks atool unrar ffmpegthumbnailer

$ ranger --copy-config=all

$ nvim .config/ranger/rc.conf

set preview_images true
set preivew_images_method ueberzug
set update_title true
set line_number relative
set one_indexed true


$ nvim .config/ranger/scope.sh

(Comment out pdf preview as images)
(Comment out video thumbnail)


( Add icon to ranger )

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

echo "default_linemode devicons" >> ~/.config/ranger/rc.conf

nvim ~/.config/ranger/plugins/ranger_devicons/__init__.py

```

#### .bashrc / .zshrc

```
$ nvim .bashrc   /   nvim .zshrc

force_color_prompt=yes

export VISUAL=nvim
export EDITOR=nvim
export BAT_THEME=gruvbox-dark

alias sysupdate='sudo pacman -Syyu'
alias sysinstall='sudo pacman -S'
alias yayupdate='yay -Syyu'
alias yayinstall='yay -S'
alias checkorphans='sudo pacman -Qtdq'
alias removeorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias yayremoveorphans='yay -Yc'
alias sysremove='sudo pacman -Rns'
alias yayremove='yay -Rns'
alias paccachecheck='paccache -d'
alias paccacheremove='paccache -r'
alias cachecheck='sudo du -sh ~/.cache/'
alias cacheremove='rm -rf ~/.cache/*'

alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias le='env EXA_ICON_SPACING=2 exa -lU --git --icons'
alias lt='env EXA_ICON_SPACING=2 exa -TlUS --octal-permissions --git --icons --time-style long-iso'
alias i3readme='nvim ~/Linux/i3-gaps.Arch/README.md'
alias i3config='nvim ~/.config/i3/config'
alias gitlog='git log --graph --all'
alias tmuxconfig='sudo nvim ~/.tmux.conf'
alias nvimconfig='nvim ~/.config/nvim/init.vim'
alias nviminstall='nvim +PlugInstall'
alias nvimupdate='nvim +PlugUpdate'

ZLE_RPROMPT_INDENT=0
```

#### No pass for Pamac Manager

```
$ su
$ cd /etc/polkit-1/rules.d
$ nvim 99-pamac.rules

polkit.addRule(function(action, subject) {
	if (action.id.indexOf("org.freedesktop.pamac-manager.")) {
		return polkit.Result.YES;
	}
});
```

#### Core editor of git

```
$ git config --global core.editor 'nvim'
```

#### Betterlockscreen

```
$ sudo pacman -S xorg-xdpyinfo xorg-xrandr bc feh
$ betterlockscreen -u Pictures/arch.png -b 1.0
```

#### Lightdm settings

```
Note: Put PNG or JPG images in /usr/share/pixmaps

$ sudo cp ~/Pictures/Wallpapers/1920x1080/lockscreen1.png /usr/share/pixmaps/

```

#### Powerline Terminal

```
OSH_THEME="cupcake" 	( .bashrc )
$ nvim .oh-my-bash/themes/cupcake/cupcake.theme.sh
```

#### Failed to update core (unable to lock database)

```
$ sudo rm /var/lib/pacman/db.lck
```

#### QtCreator

```
Enable run in terminal

/usr/bin/kitty      -e

$ mkdir -p ~/.config/QtProject/qtcreator/styles
$ nvim ~/.config/QtProject/qtcreator/styles/gruvbox-dark.xml
```

#### Tmux Gruvbox

```
$sudo nvim ~/.tmux.conf
(https://github.com/egel/tmux-gruvbox)


```

#### bpytop gruvbox theme

```
$ nvim ~/.config/bpytop/bpytop.conf
color_theme="gruvbox_dark"
```

#### Oh-my-bash

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```
