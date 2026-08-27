#!/bin/bash

quarto render
touch docs/.nojekyll

#rename pdf with date

#DATE=$(date +%Y-%m-%d)

#quarto render --to pdf

PDF="docs/FastMAPOL-Algorithm-Theoretical-Basis-Document.pdf"

#if [ -f "$PDF" ]; then
#    mv "$PDF" "docs/FastMAPOL-ATBD-${DATE}.pdf"
#fi

cp $PDF /mnt/mfs/FILESHARE/meng_gao/pace/atbd/
