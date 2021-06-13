# i3-gaps.Arch

## Active wifi from Network Manager

```
$ nmtui
$ sudo pacman -syy
```

## install packages

```
$ sudo pacman -s xorg-server xfce4 xfce4-goodies (^6 ^11 | ^1 ^12 ^14 ^19 ^36)
$ xorg-xinitrc i3-gaps i3blocks rofi feh lxappearance ranger nvidia-lts/nvidia nvidia-utils nvidia-settings

$ sudo pacman -s kitty qutebrowser firefox vlc gimp file-roller pavucontrol lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings evince galculator neofetch gufw clamtk libreoffice-fresh exa tmux bpytop bleachbit gpick

i3blocks -> (sysstat acpi acpilight)

( xf86-video-intel/xf86-video-amdgpu pcmanfm nnn picom geany geany-plugins nitrogen gpicview chromium)
```

## prepare for start up

```
$ cp /etc/x11/xinit/xinitrc .xinitrc
$ nvim .xinitrc

exec i3
```

```
$ sudo systemctl enable lightdm ( if we use lightdm, otherwise "gdm" - gnome, "sddm" - kde )
```

## post installation

#### i3 config

```
$ nvim ~/.config/i3/config

( update rofi, kitty )
```

#### fonts

```
$ sudo pacman -s otf-font-awesome otf-cascadia-code ttf-fira-code ttf-droid ttf-joypixels ttf-nerd-fonts-symbols
```

#### install wifi for kernel module

```
* install

$ git clone https://github.com/lwfinger/rtw88.git
$ cd rtw88
$ make
$ sudo make install


* disable/enable a kernel module

$ sudo modprobe -r rtw_8723de         #this unloads the module
$ sudo modprobe rtw_8723de            #this loads the module

* when kenel changes, have to update
$ cd ~/rtw88
$ git pull
$ make
$ sudo make install
```

#### neovim plug manager

```
sh -c 'curl -flo "${xdg_data_home:-$home/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

#### install python packages

```
$ sudo pacman -s python-pygame python-requests python-pandas python-beautifulsoup4

($ sudo pacman -s python-pylint python-openpyxl )
```

#### install steam

```
$ sudo nvim /etc/pacman.conf
[multilib]
include = /etc/pacman.d/mirrorlist

$ sudo pacman -s wqy-zenhei steam
choose nvidia vulcan (2)
```

#### install zsh

```
$ sudo pacman -s zsh

(set zsh default shell)
$ chsh -s $(which zsh)

(oh-my-zsh)
$ sh -c "$(curl -fssl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

(zsh-syntax-highlighting)
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_custom/plugins/zsh-syntax-highlighting

$ nvim ~/.zshrc
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

(powerlevel10)
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${zsh_custom:-$home/.oh-my-zsh/custom}/themes/powerlevel10k

nvim ~/.zshrc
$ zsh_theme="powerlevel10k/powerlevel10k"

(zsh-autosuggestions)
$ git clone https://github.com/zsh-users/zsh-autosuggestions.git $zsh_custom/plugins/zsh-autosuggestions

```

## app configures

#### neovim

```
$ sudo pacman -s clang nodejs npm ctags the_silver_searcher gopls
```

#### ranger

```
$ sudo pacman -s bat ueberzug elinks atool unrar ffmpegthumbnailer

$ ranger --copy-config=all

$ nvim .config/ranger/rc.conf

set preview_images true
set preivew_images_method ueberzug
set update_title true
set line_number relative
set one_indexed true


$ nvim .config/ranger/scope.sh

(comment out pdf preview as images)
(comment out video thumbnail)


( add icon to ranger )

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

echo "default_linemode devicons" >> ~/.config/ranger/rc.conf

nvim ~/.config/ranger/plugins/ranger_devicons/__init__.py

(update icon of .h file)


( delete to trash - use dd )
$ nvim ~/.config/ranger/rc.conf

map dd shell mv %s /home/${user}/.local/share/trash/files/


(archive / extract)

from ranger.core.loader import commandloader

class extract_here(command):
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
        self.fm.cut_buffer = false
        if len(marked_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = commandloader(args=['aunpack'] + au_flags
                            + [f.path for f in marked_files], descr=descr,
                            read=true)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class compress(command):
    def execute(self):
        """ compress marked files to current directory """
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
        obj = commandloader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr, read=true)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]

```

#### .bashrc / .zshrc

```
$ nvim .bashrc   /   nvim .zshrc

force_color_prompt=yes

export visual=nvim
export editor=nvim
export bat_theme=gruvbox-dark

#------------------- system --------- syntax: s(sudo), y(yay), rm(remove), pcache(paccache)
alias supd='sudo pacman -syyu'
alias sins='sudo pacman -s'
alias srm='sudo pacman -rns'

alias yupd='yay -syyu'
alias yins='yay -s'
alias yrm='yay -rns'

alias sorphans='sudo pacman -qtdq'
alias srmorphans='sudo pacman -rns $(pacman -qtdq)'
alias yrmorphans='yay -yc'
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

#----------------- config -------- rdm(readme), conf(config)
alias i3gapsrdm='nvim ~/linux/i3-gaps.arch/readme.md'
alias archrdm='nvim ~/linux/arch/readme.md'
alias i3conf='nvim ~/.config/i3/config'
alias i3blocksconf='nvim ~/.config/i3blocks/config'
alias tmuxconf='sudo nvim ~/.tmux.conf'
alias xinitrc='nvim ~/.xinitrc'
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias kittyconf='nvim ~/.config/kitty/kitty.conf'
alias neofetchconf='nvim ~/.config/neofetch/config.conf'
alias nvconf='nvim ~/.config/nvim/init.vim'

alias racommand='nvim ~/.config/ranger/commands.py'
alias rarc='nvim ~/.config/ranger/rc.conf'
alias rascope='nvim ~/.config/ranger/scope.sh'
alias rarifle='nvim ~/.config/ranger/rifle.conf'

#---------------- dir
alias i3gapsdir='cd ~/linux/i3-gaps.arch'
alias i3gapsra='ranger ~/linux/i3-gaps.arch'
alias archdir='cd ~/linux/arch'
alias archra='ranger ~/linux/arch'
alias i3dir='cd ~/.config/i3'
alias i3ra='ranger ~/.config/i3'
alias i3blocksdir='cd ~/.config/i3blocks'
alias i3blocksra='ranger ~/.config/i3blocks'
alias fontsdir='cd ~/.local/share/fonts'
alias fontsra='ranger ~/.local/share/fonts'
alias radir='cd ~/.config/ranger'
alias rara='ranger ~/.config/ranger'

#--------------- shortcut ------------- nf(neofetch), rg(ranger), f(find)
alias snv='sudo nvim'
alias nv='nvim'
alias nvins='nvim +pluginstall'
alias nvupd='nvim +plugupdate'
alias nvcl='nvim +plugclean'

alias le='env exa_icon_spacing=2 exa -lu --git --icons'
alias lt='env exa_icon_spacing=2 exa -tlus --octal-permissions --git --icons --time-style long-iso'

alias gadd='git add .'
alias gcommit='git commit'
alias glog='git log --graph --all'
alias gstatus='git status'
alias gpush='git push'
alias gpull='git pull'
alias gclone='git clone'
alias gconf='git config'
alisa gapply='git apply'

alias ra='ranger'
alias vlcm='vlc -i ncurses --no-video'

alias ffile='find . -type f -iname' 
alias fdir='find . -type d -iname'
alias femptyfile='find . -type f -empty'
alias femptydir='find . -type d -empty'

alias rdm='nvim README.md'

zle_rprompt_indent=0
```

#### xbacklight scrolling

```
$ su
$ nvim /etc/sudoers

%wheel all=(all) nopasswd: /usr/bin/xbacklight
```

#### lightdm settings

```
note: put png or jpg images in /usr/share/pixmaps

$ sudo cp ~/pictures/wallpapers/1920x1080/lockscreen1.png /usr/share/pixmaps/


$ sudo nvim /etc/lightdm/lightdm-gtk-greeter.conf

[greeter]
theme-name = gruvbox-material-dark
icon-theme-name = gruvbox-material-dark
font-name = sans 16
background = /usr/share/pixmaps/lockscreen1.png
default-user-image = /usr/share/pixmaps/archlinux-logo.png
clock-format = %a, %h-%d-%y (%h:%m:%s)
indicators = ~host;~spacer;~clock;~spacer;~session;~layout;~a11y;~power

```

#### bpytop gruvbox theme

```
$ nvim ~/.config/bpytop/bpytop.conf
color_theme="gruvbox_dark"
```

#### neofetch (default config)

```
$ sudo nvim $(which neofetch)

arch_old (+3 space)
```

#### install yay

```
$ cd /opt
$ sudo git clone https://aur.archlinux.org/yay.git
$ sudo chown -r henry:users ./yay
$ cd yay
$ makepkg -si
```

#### install aur packages

```
$ yay -s zoom visual-studio-code-bin  gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git optimus-manager optimus-manager-qt picom-ibhagwan-git imagewriter

( $ yay -s heroku-cli polybar gotop pamac-aur ttf-iosevka ttf-icomoon-feather ttf-font-icons)

( $ sudo systemctl enable optimus-manager )
( $ sudo systemctl start optimus-manager )
```

#### no pass for pamac manager

```
$ su
$ cd /etc/polkit-1/rules.d
$ nvim 99-pamac.rules

polkit.addrule(function(action, subject) {
	if (action.id.indexof("org.freedesktop.pamac-manager.")) {
		return polkit.result.yes;
	}
});
```

#### core editor of git

```
$ git config --global core.editor 'nvim'
```

#### betterlockscreen

```
$ sudo pacman -s xorg-xdpyinfo xorg-xrandr bc feh
$ betterlockscreen -u pictures/arch.png -b 1.0
```

#### powerline terminal

```
osh_theme="cupcake" 	( .bashrc )
$ nvim .oh-my-bash/themes/cupcake/cupcake.theme.sh
```

#### failed to update core (unable to lock database)

```
$ sudo rm /var/lib/pacman/db.lck
```

#### qtcreator

```
enable run in terminal

/usr/bin/kitty      -e

$ mkdir -p ~/.config/qtproject/qtcreator/styles
$ nvim ~/.config/qtproject/qtcreator/styles/gruvbox-dark.xml
```

#### oh-my-bash

```
bash -c "$(curl -fssl https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

#### install fonts manually

```
mkdir -p /usr/local/share/fonts

sudo chmod 555 ~/.local/share/fonts/
sudo chmod 444 ~/.local/share/fonts/*
```

#### firefox
```
(https://github.com/mrotherguy/firefox-csshacks/tree/master/chrome)

$ cd .mozilla/firefox
$ le
$ cd (...).default-release

$ mkdir chrome      (cd chrome)
$ mvdir ~/linux/i3-gaps.arch/firefox/userchrome.css ~/.mozilla/firefox/(...).default-release/chrome/
```

#### thunar (open with terminal app)
```
$ sudo nvim /usr/share/applications/nvim.desktop 

Exec=kitty -e nvim %F
Terminal=false

```

