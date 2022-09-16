#
#     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
#     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
#     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
#     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
#     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
#     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
#

if status is-interactive
    # Commands to run in interactive sessions can go here

# Locale for fish
set LANG "en_IN.utf8"
set -x LC_ALL en_IN.UTF-8
set -x LC_CTYPE en_IN.UTF-8

### Set timedatectl synchronization on
alias set-time ='timedatectl set-ntp true'

### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type
set EDITOR "nvim" 

### PATH

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal '#8060f2'
set fish_color_autosuggestion '#404040'
set fish_color_command '#00e5ff'
set fish_color_error '#f24054'
set fish_color_param '#d0d0d0'


########################################################################
###############                 FUNCTION                 ###############
########################################################################

##### make directory and CD into folder #########
function mkdir-cd
    mkdir -p -- $argv && cd -- $argv
end

######## MOVE#######
function move
    mv -i $argv
end

######## backup file
function backup --argument filename
    cp $filename $filename.bak
end

function remove
    set original_args $argv

    argparse r f -- $argv

    if not set -q _flag_r || set -q _flag_f
        rm $original_args
        return
    end

    function confirm-remove --argument dir
        set display_dir (echo $dir | unexpand-home-tilde)

        if confirm "Remove .git directory $display_dir?"
            rm -rf $dir
            return
        end

        echo 'Cancelling.'
        return 1
    end

    for f in $argv
        set gitdirs (find $f -name .git)
        for gitdir in $gitdirs
            confirm-remove $gitdir
        end
    end

    rm $original_args
end

function confirm
    read -P "$argv> " response
    contains $response y Y yes YES
end

function clean-unzip --argument zipfile
    if not test (echo $zipfile | string sub --start=-4) = .zip
        echo (status function): argument must be a zipfile
        return 1
    end

    if is-clean-zip $zipfile
        unzip $zipfile
    else
        set zipname (echo $zipfile | trim-right '.zip')
        mkdir $zipname || return 1
        unzip $zipfile -d $zipname
    end
end

function unzip-cd --argument zipfile
    clean-unzip $zipfile && cd (echo $zipfile | trim-right .zip)
end

########################################################################
###############               ALIASES            ###############
########################################################################

#vim
alias vim="nvim"
alias svim="sudo nvim"

#Make a directory with parent-child
alias mkdir="mkdir -p"

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

#Custom Clear command
alias clr='clear;colorscript random'

# fastboot sudo permition
alias fastboot='sudo fastboot'

#dd command
alias dd='sudo dd bs=4M status=progress'
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Changing "ls" to "exa"
alias ls='exa -alh --color=always --group-directories-first' # listing
alias la='exa -ah --color=always --group-directories-first'  # all files and dirs
alias ll='exa -lh --color=always --group-directories-first'  # long format
alias lt='exa -aTh --color=always --group-directories-first' # tree listing
alias l.='exa -ah | egrep "^\."'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#pacman command
alias pacins='sudo dnf install'
alias pacrmv='sudo dnf remove --noautoremove'
alias pacrmvwd='sudo dnf remove'
alias pacup='sudo dnf update systemd'
alias search='dnf search'
alias cleanup='sudo dnf autoremove'
alias dnflist='dnf grouplist'
alias groupins='sudo dnf groupinstall'
alias grouprmv='sudo dnf groupremove'


#Source config
alias fsource='source ~/.config/fish/config.fish'
alias bsource='source ~/.bashrc'

#wifi
alias wifi="nmtui"

#chmod
alias mod="sudo chmod +x"

#change ownership
alias ownfi='sudo chown $USER'
alias ownfo='sudo chown -R $USER'

# git
alias gst='git status'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

#list all drive with UUID
alias list_drive='lsblk -f'

#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#grub update
alias grub-update="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#Edit with your EDITOR for important configuration files
alias nlightdm="sudo $EDITOR /etc/lightdm/lightdm.conf"
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nsddm="sudo $EDITOR /usr/lib/sddm/sddm.conf.d/default.conf"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nbash="$EDITOR ~/.bashrc"
alias nzsh="$EDITOR ~/.zshrc"
alias nfish="$EDITOR ~/.config/fish/config.fish"
alias nbspwm="$EDITOR ~/.config/bspwm/bspwmrc"
alias nsxhkd="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias ndnf="sudo $EDITOR /etc/dnf/dnf.conf"

#Edit config file for ricing
alias ni3="$EDITOR ~/.config/i3/config"
alias npolybar="$EDITOR ~/.config/polybar/config"
alias nkitty="$EDITOR ~/.config/kitty/kitty.conf"
alias nalacritty="$EDITOR ~/.config/alacritty/alacritty.yml"
alias npicom="$EDITOR ~/.config/picom/picom.conf"
alias nxresources="$EDITOR ~/.Xresources"
alias nstarship="$EDITOR ~/.config/starship.toml"
alias nneofetch="$EDITOR ~/.config/neofetch/config.conf"

#shutdown or reboot
alias shutdown="shutdown now"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# the terminal rickroll
alias rr='curl -s -L http://bit.ly/10hA8iC | bash'

########################################################################
###############                   Styling                ###############
########################################################################

##starship config
starship init fish | source


end