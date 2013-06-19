#!/usr/bin/env sh

LINKS=ln
OPTION=-s
DOTDIR=~/dotfile/
TARGETDIR=~/
#${LINKS} ${OPTION_SYM} ${DOTDIR}
${LINKS} ${OPTION} ${DOTDIR}zshrc.linux ${TARGETDIR}.zshrc
${LINKS} ${OPTION} ${DOTDIR}zshrc.d ${TARGETDIR}.zshrc.d
${LINKS} ${OPTION} ${DOTDIR}tmux.conf.linux ${TARGETDIR}.tmux.conf
${LINKS} ${OPTION} ${DOTDIR}emacs.el ${TARGETDIR}.emacs.el
${LINKS} ${OPTION} ${DOTDIR}emacs.d ${TARGETDIR}.emacs.d
${LINKS} ${OPTION} ${DOTDIR}elisp ${TARGETDIR}./

