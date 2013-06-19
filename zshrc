## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8

case ${OSTYPE} in
     darwin*)
        export TEXPATH=/Applications/UpTeX.app/teTeX/bin:/Applications/pTeX.app/teTeX/bin:/Applications/Xpdf.app:/Applications/Xpdf.app/bin
        export PATH=/usr/local/share/python:$HOME/opt/sbin:$HOME/opt/bin:$TEXPATH:/Applications/Maxima.app/bin:/Applications/gnuplot.app/bin:/opt/local/bin:/usr/local/bin:$PATH
        [ -f /opt/local/bin/src-hilite-lesspipe.sh ] && export LESSOPEN='| /opt/local/bin/src-hilite-lesspipe.sh %s'
        [ -f /usr/local/etc/profile.d/z.sh ] && source /usr/local/etc/profile.d/z.sh
        [ -f ${HOME}/.zshrc.d/zshrc.mac ] && source ${HOME}/.zshrc.d/zshrc.mac
     ;;
     *)
        export PATH=$HOME/opt/sbin:$HOME/opt/bin:/opt/local/bin:/usr/local/bin:$PATH:
     ;;
esac


## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.d/zshrc.common ] && source ${HOME}/.zshrc.d/zshrc.common
