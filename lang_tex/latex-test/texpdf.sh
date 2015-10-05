#! /bin/bash
[ -z "$1" ] && echo missing filename && exit 1
name=${1%.tex}
echo $name
#name=$(basename -s "$1" || echo error in basename && echo exit && error=1 && exit 1)

[ -n "$error" ] && echo error detected && exit 1
echo $name
echo all is OK
#latex "$name".tex && dvips "$name".dvi && ps2pdf "$name".ps
