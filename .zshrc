# Created by newuser for 5.8.1

#
#     ██╗      █████╗ ██╗  ██╗███████╗██╗  ██╗███╗   ███╗██╗██╗  ██╗ █████╗ ███╗   ██╗████████╗ █████╗
#     ██║     ██╔══██╗██║ ██╔╝██╔════╝██║  ██║████╗ ████║██║██║ ██╔╝██╔══██╗████╗  ██║╚══██╔══╝██╔══██╗
#     ██║     ███████║█████╔╝ ███████╗███████║██╔████╔██║██║█████╔╝ ███████║██╔██╗ ██║   ██║   ███████║
#     ██║     ██╔══██║██╔═██╗ ╚════██║██╔══██║██║╚██╔╝██║██║██╔═██╗ ██╔══██║██║╚██╗██║   ██║   ██╔══██║
#     ███████╗██║  ██║██║  ██╗███████║██║  ██║██║ ╚═╝ ██║██║██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║
#     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝
#

#Locale for terminal
export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"
export LC_CTYPE="en_IN.UTF-8"

###EXPORT
export TERM="xterm-256color"             # getting proper colors
export EDITOR="nvim"                     # $EDITOR use NeoVim in terminal
export VISUAL="nvim"                     # $VISUAL use NeoVim in GUI mode

export SUDO_EDITOR="nvim"
alias "sudoedit"='function _sudoedit(){sudo -e "$1";};_sudoedit'

### CHANGE TITLE OF TERMINALS
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac
############################
####  Source plugins

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh

##############################################################################
# History Configuration
##############################################################################
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

########################################################################
###############                 FUNCTION                 ###############
########################################################################

#source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

############# Function extract for common file formats ###
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS

############# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

########################################################################
###############               ALIASES            ###############
########################################################################

#vim
alias vim="nvim"
alias svim="sudo nvim"

#Make a directory with parent-child
alias mkdir="mkdir -p"

# confirm before overwriting something
alias cp="cp -i -r"
alias mv='mv -i'
alias rm='rm -i'

#Custom Clear command
alias clr='clear;colorscript random'

# fastboot sudo permition
alias fastboot='sudo fastboot'

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

#dnf command
alias pacins='sudo dnf install'
alias pacrmv='sudo dnf remove'
alias pacrmv-d='sudo dnf autoremove'          # remove orphaned packages
alias cleanup='sudo dnf clean all'            
alias pacup='sudo dnf update'
alias pacsearch='dnf search'

#Source config
alias fsource='source ~/.config/fish/config.fish'
alias bsource='source ~/.bashrc'
alias zsource='source ~/.zshrc'

#wifi & bluetooth
alias wifi="nmtui"
alias blue="blueberry"

#font listing
alias flist='fc-list | grep'

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
alias gemail='git config --global user.email'
alias gname='git config --global user.name'

# script to arch system maintaincence
#To download this https://github.com/voider755/almh.git
# arch user "yay -S almh-git"
alias maintaincence='almh.py'

#list all drive with UUID
alias list_drive='lsblk -f'

#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"


#get fastest mirrors in your neighborhood
# Download reflector "sudo pacman -S reflector"
alias mirror="sudo reflector -f 30 -l 10 --number 10 --verbose  --sort rate --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 10 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 10 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 10 --number 10 --sort age --save /etc/pacman.d/mirrorlist"

#Recent Installed Packages
# Download expac "sudo pacman -S expac"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -20 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#Edit with your EDITOR for important configuration files
alias nlightdm="sudo $EDITOR /etc/lightdm/lightdm.conf"
alias npacman="sudo $EDITOR /etc/pacman.conf"
alias nparu="sudo $EDITOR /etc/paru.conf"
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nconfgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias nmkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias nmirrorlist="sudo $EDITOR /etc/pacman.d/mirrorlist"
alias narcomirrorlist='sudo $EDITOR /etc/pacman.d/arcolinux-mirrorlist'
alias nsddm="sudo -e /usr/lib/sddm/sddm.conf.d/default.conf"
alias nfstab="sudo -e /etc/fstab"
alias nbash="$VISUAL ~/.bashrc"
alias nzsh="$VISUAL ~/.zshrc"
alias nfish="$VISUAL ~/.config/fish/config.fish"
alias ndnf="EDITOR /etc/dnf/dnf.conf"
alias nbspwm="$VISUAL ~/.config/bspwm/bspwmrc"
alias nsxhkd="$VISUAL ~/.config/sxhkd/sxhkdrc"
alias nsourcelist="sudo $EDITOR /etc/apt/sources.list"

#Edit config file for riceing
alias ni3="$VISUAL ~/.config/i3/config"
alias npolybar="$VISUAL ~/.config/polybar/config"
alias nkitty="$VISUAL ~/.config/kitty/kitty.conf"
alias nalacritty="$VISUAL ~/.config/alacritty/alacritty.yml"
alias npicom="$VISUAL ~/.config/picom/picom.conf"
alias nxresources="$VISUAL ~/.Xresources"
alias nstarship="$VISUAL ~/.config/starship.toml"
alias nneofetch="$VISUAL ~/.config/neofetch/config.conf"
#systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"

#shutdown or reboot
alias shutdown="sudo shutdown now"
alias reboot="sudo reboot"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# the terminal rickroll
alias rr='curl -s -L http://bit.ly/10hA8iC | bash'

# youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "


########################################################################
###############                   Styling                ###############
########################################################################

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
# colorscript random

#Custimize scripts
  #neofetch
  # figlet -c -f doom 'Lakshmikanta'
  # fm6000 -random -color random

#starship startup scripts
eval "$(starship init zsh)"
