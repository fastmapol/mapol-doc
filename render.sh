#!/bin/bash

#generate both pdf and html
#quarto render

#generate html only
#already handle by github action
#quarto render --to html
#touch docs/.nojekyll


#generate pdf only
quarto render --to pdf
PDF="docs/FastMAPOL-Algorithm-Theoretical-Basis-Document.pdf"

#if need to rename pdf with date
#DATE=$(date +%Y-%m-%d)
#if [ -f "$PDF" ]; then
#    mv "$PDF" "docs/FastMAPOL-ATBD-${DATE}.pdf"
#fi

#put it into a share dir
cp $PDF /mnt/mfs/FILESHARE/meng_gao/pace/atbd/
