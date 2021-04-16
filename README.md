# i3-gaps.Arch


## Active wifi from Network Manager
```
$ nmtui
$ sudo pacman -Syy
```

## Install packages
```
$ sudo pacman -S (xf86-video-intel/xf86-video-amdgpu) (nvidia-lts/nvidia nvidia-utils nvidia-settings) xorg-server xorg-xinit i3-gaps i3lock i3status i3blocks rofi nitrogen kitty qutebrowser firefox lxappearance vlc gimp  file-roller pavucontrol lightdm lightdm-gtk-greeter neofetch gufw clamtk nodejs npm ctags ranger the_silver_searcher plank libreoffice-fresh

( $ sudo pacman -S lightdm-gtk-greeter-settings evince galculator )

pcmanfm gpicview nnn
```
 
## Prepare for start up
```
$ (cp /etc/X11/xinit/xinitrc .xinitrc)
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

#### Oh-my-bash
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

#### Remove orphans
```
$ sudo pacman -Qtdq
$ sudo pacman -Rns $(pacman -Qtdq)
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
$ yay -S polybar pamac-aur zoom visual-studio-code-bin gotop ttf-ms-fonts ttf-iosevka ttf-icomoon-feather ttf-font-icons
( $ yay -S gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git heroku-cli optimus-manager optimus-manager-qt betterlockscreen )

( $ sudo systemctl enable optimus-manager )
( $ sudo systemctl start optimus-manager )
```

#### Install Python packages
```
$ sudo pacman -S python-pygame python-requests python-pandas python-beautifulsoup4 python-openpyxl
```



## App configures
#### Ranger
```
cp /usr/share/doc/ranger/config/rifle.conf .config/ranger/
cp /usr/share/doc/ranger/config/rc.conf .config/ranger/

$ sudo pacman -S highlight mediainfo w3m python-pillow

$ nvim .config/ranger/rc.conf

(Enable Image preview for ranger on Kitty)

set preview_images true
set preivew_images_method kitty


(Add icon to ranger)

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

echo "default_linemode devicons" >> ~/.config/ranger/rc.conf

nvim ~/.config/ranger/plugins/ranger_devicons/__init__.py   


( Enable document view in nvim from ranger )

$ nvim .bashrc

force_color_prompt=yes
export VISUAL=nvim;
export EDITOR=nvim;
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
```

#### Powerline Terminal
```
OSH_THEME="cupcake" 	( .bashrc )
$ nvim .oh-my-bash/themes/cupcake/cupcake.theme.sh
```
