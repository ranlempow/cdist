#!/bin/sh
#
# 2011 Nico Schottelius (nico-cdist at schottelius.org)
#
# This file is part of cdist.
#
# cdist is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# cdist is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with cdist. If not, see <http://www.gnu.org/licenses/>.
#
#
# Push a directory to a target, both sides have the same name (i.e. explorers)
# or
# Pull a directory from a target, both sides have the same name (i.e. explorers)
#

# exit on any error
#set -e

# Manpage and HTML
A2XM="a2x -f manpage --no-xmllint"
A2XH="a2x -f xhtml --no-xmllint"

# Developer webbase
WEBDIR=$HOME/niconetz
WEBBASE=software/cdist
WEBPAGE=${WEBBASE}.mdwn

# Documentation
MANDIR=doc/man
MAN1DSTDIR=${MANDIR}/man1
MAN7DSTDIR=${MANDIR}/man7
SPEECHESDIR=doc/speeches

case "$1" in
   man)
      set -e
      "$0" mangen
      "$0" mantype
      "$0" manbuild
   ;;

   manbuild)
      trap abort INT
      abort() {
         kill 0
      }
      for section in 1 7; do
         for src in ${MANDIR}/man${section}/*.text; do
            manpage="${src%.text}.$section"
            if [ ! -f "$manpage" -o "$manpage" -ot "$src" ]; then
               echo "Compiling man page for $src"
               $A2XM "$src"
            fi
            htmlpage="${src%.text}.html"
            if [ ! -f "$htmlpage" -o "$htmlpage" -ot "$src" ]; then
               echo "Compiling html page for $src"
               $A2XH "$src"
            fi
         done
      done
   ;;

   mantype)
	   for mansrc in conf/type/*/man.text; do
         dst="$(echo $mansrc | sed -e 's;conf/;cdist-;'  -e 's;/;;' -e 's;/man;;' -e 's;^;doc/man/man7/;')"
         ln -sf "../../../$mansrc" "$dst"
      done
   ;;

   mangen)
      ${MANDIR}/cdist-reference.text.sh
   ;;

   release)
      "$0" clean && "$0" man && "$0" web
   ;;

   speeches)
      cd "$SPEECHESDIR"
      for speech in *tex; do
         pdflatex "$speech"
         pdflatex "$speech"
         pdflatex "$speech"
      done
   ;;
      
   web)
      cp README ${WEBDIR}/${WEBPAGE}
      rm -rf ${WEBDIR}/${WEBBASE}/man && mkdir ${WEBDIR}/${WEBBASE}/man
      rm -rf ${WEBDIR}/${WEBBASE}/speeches && mkdir ${WEBDIR}/${WEBBASE}/speeches

      cp ${MAN1DSTDIR}/*.html ${MAN7DSTDIR}/*.html ${WEBDIR}/${WEBBASE}/man
      cp ${SPEECHESDIR}/*.pdf ${WEBDIR}/${WEBBASE}/speeches
      
      git describe > ${WEBDIR}/${WEBBASE}/man/VERSION
      cd ${WEBDIR} && git add ${WEBBASE}
      cd ${WEBDIR} && git commit -m "cdist update" ${WEBBASE} ${WEBPAGE}
      cd ${WEBDIR} && make pub
   ;;

   pub)
      git push --mirror
      git push --mirror github
   ;;

   clean)
      rm -f ${MAN7DSTDIR}/cdist-reference.text
      find "${MANDIR}" -mindepth 2 -type l \
         -o -name "*.1" \
         -o -name "*.7" \
         -o -name "*.html" \
         -o -name "*.xml" \
      | xargs rm -f
   ;;

   *)
      echo ''
      echo 'Welcome to cdist!'
      echo ''
      echo 'Here are the possible targets:'
      echo ''
      echo '	man: Build manpages (requires Asciidoc)'
      echo '	clean: Remove build stuff'
      echo ''
      echo ''
      echo "Unknown target, \"$1\"" >&2
      exit 1
   ;;
esac
