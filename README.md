# i3-gaps.Arch

## Active wifi from Network Manager

```
$ nmtui
$ sudo pacman -Syy
```

## Install packages

```
$ sudo pacman -S (xf86-video-intel/xf86-video-amdgpu) (nvidia-lts/nvidia nvidia-utils nvidia-settings) xorg-server xfce4 xfce4-goodies
( $ sudo pacman -S i3-gaps i3blocks rofi feh lxappearance ranger )

$ sudo pacman -S kitty qutebrowser firefox chromium vlc gimp file-roller pavucontrol lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings evince galculator neofetch gufw clamtk libreoffice-fresh exa tmux bpytop bleachbit


i3blocks -> (sysstat acpi acpilight)

(pcmanfm nnn picom geany geany-plugins nitrogen gpicview)
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
$ yay -S zoom visual-studio-code-bin ttf-iosevka ttf-icomoon-feather ttf-font-icons gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git optimus-manager optimus-manager-qt picom-ibhagwan-git imagewriter

( $ yay -S heroku-cli polybar gotop pamac-aur)

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
$ sudo pacman -S zsh 

(Set zsh default shell)
$ chsh -s $(which zsh)

(oh-my-zsh)
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

(zsh-syntax-highlighting)
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

$ nvim ~/.zshrc
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

(powerlevel10)
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

nvim ~/.zshrc
$ ZSH_THEME="powerlevel10k/powerlevel10k"

(zsh-autosuggestions)
$ git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

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


(Archive / Extract)

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
alias sysremove='sudo pacman -Rns'
alias yayupdate='yay -Syyu'
alias yayinstall='yay -S'
alias yayremove='yay -Rns'
alias checkorphans='sudo pacman -Qtdq'
alias removeorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias yayremoveorphans='yay -Yc'
alias paccachecheck='paccache -d'
alias paccacheremove='paccache -r'
alias cachecheck='sudo du -sh ~/.cache/'
alias cacheremove='rm -rf ~/.cache/*'

alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
alias le='env EXA_ICON_SPACING=2 exa -lU --git --icons'
alias lt='env EXA_ICON_SPACING=2 exa -TlUS --octal-permissions --git --icons --time-style long-iso'
alias i3archreadme='nvim ~/Linux/i3-gaps.Arch/README.md'
alias i3archdir='cd ~/Linux/i3-gaps.Arch'
alias archreadme='nvim ~/Linux/Arch/README.md'
alias archdir='cd ~/Linux/Arch'
alias i3config='nvim ~/.config/i3/config'
alias i3dir='cd ~/.config/i3'
alias i3blocksconf='nvim ~/.config/i3blocks/config'
alias i3blocksdir='cd ~/.config/i3blocks'
alias gitlog='git log --graph --all'
alias gitstatus='git status'
alias tmuxconfig='sudo nvim ~/.tmux.conf'
alias nv='nvim'
alias nvconfig='nvim ~/.config/nvim/init.vim'
alias nvinstall='nvim +PlugInstall'
alias nvupdate='nvim +PlugUpdate'
alias nvclean='nvim +PlugClean'
alias ra='ranger'
alias xinitrc='nvim ~/.xinitrc'
alias ex='exit'
alias cl='clear'


ZLE_RPROMPT_INDENT=0
```


#### xbacklight scrolling

```
$ su
$ nvim /etc/sudoers

%wheel ALL=(ALL) NOPASSWD: /usr/bin/xbacklight
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


