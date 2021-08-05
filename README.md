# i3-gaps.Arch

## Active wifi from Network Manager

```
$ (sudo wifi-menu)/(nmtui)
$ sudo pacman -Syy
```

## Install packages

```
(XFCE)
$ sudo pacman -S xorg-server xfce4 xfce4-goodies (^6 ^11 | ^1 ^12 ^14 ^19 ^36) lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

(i3)
i3gaps-> (xorg-xinit) i3-gaps i3blocks rofi feh lxappearance
i3blocks -> sysstat acpi acpilight playerctl (file-roller pavucontrol evince galculator gpick shotcut)

(KDE)
$ sudo pacman -S plasma-desktop plasma-nm plasma-pa kdeplasma-addons kde-gtk-config sddm sddm-kcm powerdevil apper gwenview kcolorchooser kdenlive okular discover kamoso dolphin ark kmag
($ sudo pacman -S plasma-desktop plasma-nm sddm kde-applications ( 1 5 13 14 17 21 31 44 46 51 52 53 54 55 58 60 63 64 67 71 78 87 92 102 133 142 145 150 153 156 ) )

$ sudo pacman -S ranger nvidia-lts/nvidia nvidia-utils nvidia-settings kitty qutebrowser firefox vlc gimp neofetch gufw clamtk libreoffice-fresh exa tmux obs-studio

( xf86-video-intel/xf86-video-amdgpu pcmanfm nnn picom geany geany-plugins nitrogen gpicview chromium bpytop bleachbit)
```

## Prepare for start up

```
$ cp /etc/X11/xinit/xinitrc .xinitrc
$ nvim .xinitrc

exec i3
```

```
$ sudo systemctl enable lightdm ( "gdm" - GNOME, "sddm" - KDE )
```

## Post Installation

#### Set up dirs

```
$ mkdir Linux Projects
$ cd ~/Pictures ; git clone https://github.com/henry-ta/Wallpapers ; cd ~/Linux ; git clone https://github.com/henry-ta/Arch ; git clone https://github.com/henry-ta/i3-gaps.Arch ; cd
$ cd ~/Documents ; git clone https://github.com/henry-ta/Langara ; git clone https://github.com/henry-ta/Self-Study ; cd
$ cd ~/Projects ; git clone https://github.com/henry-ta/Retro ;
```

#### i3 config

```
$ nvim ~/.config/i3/config

( Update rofi, kitty )
```

#### Fonts

```
$ sudo pacman -S otf-font-awesome otf-cascadia-code ttf-fira-code ttf-droid ttf-joypixels ttf-nerd-fonts-symbols
```

#### Neovim plug manager

```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

#### Install Python packages

```
$ sudo pacman -S python-pygame python-requests python-pandas python-beautifulsoup4

($ sudo pacman -S python-pylint python-openpyxl )
```

#### Install Steam

```
$ sudo nvim /etc/pacman.conf ; sudo pacman -S wqy-zenhei steam

[multilib]
Include = /etc/pacman.d/mirrorlist

Choose Nvidia vulcan (2)
```

#### Install zsh

```
$ sudo pacman -S zsh; chsh -s $(which zsh); sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting; nvim ~/.zshrc

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

(powerlevel10)
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

ZSH_THEME="powerlevel10k/powerlevel10k"

(zsh-autosuggestions)
$ git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

```

## App configures

#### Neovim

```
$ sudo pacman -S nodejs npm ctags the_silver_searcher gopls clang
```

#### Ranger

```
$ sudo pacman -S bat ueberzug elinks atool unrar ffmpegthumbnailer ; ranger --copy-config=all; nvim .config/ranger/rc.conf; nvim .config/ranger/scope.sh; git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons ; echo "default_linemode devicons" >> ~/.config/ranger/rc.conf ; nvim ~/.config/ranger/plugins/ranger_devicons/__init__.py; echo "map DD shell mv %s /home/${USER}/.local/share/Trash/files/" >> ~/.config/ranger/rc.conf; nvim ~/.config/ranger/commands.py; nvim ~/.config/ranger/scope.sh


set preview_images true
set preivew_images_method ueberzug
set update_title true
set line_number relative
set one_indexed true


(Comment out pdf preview as images)
(Comment out video thumbnail)


from ranger.core.loader import CommandLoader

class extract_here(Command):
    def execute(self):
        """ extract selected files to current directory."""
        cwd = self.fm.thisdir
        marked_files = tuple(cwd.get_selection())

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = marked_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-x', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(marked_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags
                            + [f.path for f in marked_files], descr=descr,
                            read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr, read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]



(Update bat theme in ranger kind binding of i3conf)
-> search bat
--theme="gruvbox-dark"


(update icon of .h file)
nvim ~/.config/ranger/plugins/ranger_devicons/devicons.py
```

#### .bashrc / .zshrc

```
$ nvim .bashrc   /   nvim .zshrc

force_color_prompt=yes

export VISUAL=nvim
export EDITOR=nvim
export BAT_THEME=gruvbox-dark

#------------------- System --------- syntax: s(sudo), y(yay), rm(remove), pcache(paccache)
alias supd='sudo pacman -Syyu'
alias sins='sudo pacman -S'
alias srm='sudo pacman -Rns'

alias yupd='yay -Syyu'
alias yins='yay -S'
alias yrm='yay -Rns'

alias sorphans='sudo pacman -Qtdq'
alias srmorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias yrmorphans='yay -Yc'
alias pcachecheck='paccache -d'
alias pcacherm='paccache -r'
alias cachecheck='sudo du -sh ~/.cache/'
alias cacherm='rm -rf ~/.cache/*'
alias chmodx='sudo chmod +x'

alias ex='exit'
alias cl='clear'
alias mk='make'
alias smk='sudo make'
alias mkcl='make clean'
alias smkcl='sudo make clean'
alias cpfile='cp -v -b -p'
alias scpfile='sudo cp -v -b -p'
alias cpdir='cp -r -v -b -p'
alias scpdir='sudo cp -r -v -b -p'
alias mvdir='mv -v -b'
alias smvdir='sudo mv -v -b'

#----------------- Config -------- rdm(readme), conf(config)
alias i3archrdm='nvim ~/Linux/i3-gaps.Arch/README.md'
alias archrdm='nvim ~/Linux/Arch/README.md'
alias i3conf='nvim ~/.config/i3/config'
alias i3blocksconf='nvim ~/.config/i3blocks/config'
alias tmuxconf='sudo nvim ~/.tmux.conf'
alias xinitrc='nvim ~/.xinitrc'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias kittyconf='nvim ~/.config/kitty/kitty.conf'
alias nfconf='nvim ~/.config/neofetch/config.conf'
alias nvconf='nvim ~/.config/nvim/init.vim'

alias racommand='nvim ~/.config/ranger/commands.py'
alias rarc='nvim ~/.config/ranger/rc.conf'
alias rascope='nvim ~/.config/ranger/scope.sh'
alias rarifle='nvim ~/.config/ranger/rifle.conf'

#---------------- Dir
alias i3archdir='cd ~/Linux/i3-gaps.Arch'
alias i3archra='ranger ~/Linux/i3-gaps.Arch'
alias archdir='cd ~/Linux/Arch'
alias archra='ranger ~/Linux/Arch'
alias i3dir='cd ~/.config/i3'
alias i3ra='ranger ~/.config/i3'
alias i3blocksdir='cd ~/.config/i3blocks'
alias i3blocksra='ranger ~/.config/i3blocks'
alias fontsdir='cd ~/.local/share/fonts'
alias fontsra='ranger ~/.local/share/fonts'
alias radir='cd ~/.config/ranger'
alias rara='ranger ~/.config/ranger'
alias nvdir='cd ~/.config/nvim'
alias nvra='ranger ~/.config/nvim'
alias wallpapersdir='cd ~/Pictures/Wallpapers'
alias wallpapersra='ranger ~/Pictures/Wallpapers'

#--------------- Shortcut ------------- nf(neofetch), rg(ranger), f(find)
alias snv='sudo nvim'
alias nv='nvim'
alias nvins='nvim +PlugInstall'
alias nvupd='nvim +PlugUpdate'
alias nvcl='nvim +PlugClean'

alias le='env EXA_ICON_SPACING=2 exa -lU --git --icons'
alias lt='env EXA_ICON_SPACING=2 exa -TlUS --octal-permissions --git --icons --time-style long-iso'

alias gadd='git add .'
alias gcomm='git commit'
alias glog='git log --graph --all'
alias gstat='git status'
alias gpush='git push'
alias gpull='git pull'
alias gclone='git clone'
alias gconf='git config'

alias ra='ranger'
alias vlcm='vlc -I ncurses --no-video'

alias ffile='find . -type f -iname'
alias fdir='find . -type d -iname'
alias femptyfile='find . -type f -empty'
alias femptydir='find . -type d -empty'

alias rdm='nvim README.md'

alias tsn='ts-node'
alias lsver='lite-server'

#--------------tmux
ZLE_RPROMPT_INDENT=0

#--------------Vietkey Bamboo
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
pidof ibus-daemon > /dev/null || ibus-daemon -drx
```

#### xbacklight scrolling

```
$ sudo echo "%wheel ALL=(ALL) NOPASSWD: /usr/bin/xbacklight" >> /etc/sudoers
```

#### Lightdm settings

```
Note: Put PNG or JPG images in /usr/share/pixmaps ; and configure

$ sudo cp ~/Pictures/Wallpapers/1920x1080/lockscreen1.png /usr/share/pixmaps/ ; sudo nvim /etc/lightdm/lightdm-gtk-greeter.conf

[greeter]
theme-name = Gruvbox-Material-Dark
icon-theme-name = Gruvbox-Material-Dark
font-name = Sans 16
background = /usr/share/pixmaps/lockscreen1.png
default-user-image = /usr/share/pixmaps/archlinux-logo.png
clock-format = %A, %h-%d-%Y (%H:%M:%S)
indicators = ~host;~spacer;~clock;~spacer;~session;~layout;~a11y;~power

```

#### bpytop gruvbox theme

```
$ nvim ~/.config/bpytop/bpytop.conf
color_theme="gruvbox_dark"
```

#### Neofetch (Default config)

```
$ sudo nvim $(which neofetch)

arch_old (+3 space)
```

#### Install Yay

```
$ cd /opt ; sudo git clone https://aur.archlinux.org/yay.git ; sudo chown -R henry:users ./yay ; cd yay ; makepkg -si
```

#### Install AUR packages

```
$ yay -S tlpui-git zoom visual-studio-code-bin  optimus-manager optimus-manager-qt imagewriter ibus-bamboo ; sudo systemctl enable optimus-manager ; sudo systemctl start optimus-manager

( $ yay -S gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git  picom-ibhagwan-git heroku-cli polybar gotop pamac-aur ttf-iosevka ttf-icomoon-feather ttf-font-icons rtw88-dkms-git)
```

#### Firefox

```
(https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome)

$ cd .mozilla/firefox
$ le
$ cd (...).default-release

$ mkdir chrome ; cpdir ~/Linux/i3-gaps.Arch/Firefox/userChrome.css ./chrome/userChrome.css

(On Firefox browser)
about:config
legacy (toolkit.legacy...) -> true
```

#### Thunar (Open with terminal app)

```
$ sudo nvim /usr/share/applications/nvim.desktop

Exec=kitty -e nvim %F
Terminal=false
```

#### No pass for Pamac Manager

```
$ su ; cd /etc/polkit-1/rules.d ; nvim 99-pamac.rules

polkit.addRule(function(action, subject) {
	if (action.id.indexOf("org.freedesktop.pamac-manager.")) {
		return polkit.Result.YES;
	}
});
```

#### Betterlockscreen

```
$ sudo pacman -S xorg-xdpyinfo xorg-xrandr bc feh
$ betterlockscreen -u Pictures/arch.png -b 1.0
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

#### Oh-my-bash

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

#### Install fonts manually

```
mkdir -p /usr/local/share/fonts
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
