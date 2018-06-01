#!/usr/bin/env bash

# Expects $1 to be the private key as a file
# Expects $2 to be the public key as a file

set -evx

split -b 128 - gpg-  < "$1"

function make_pages () {
    mkdir -vp "raw_gpg"
    mkdir -vp "png_gpg"
    mv -v "gpg"-* "raw_gpg/."

    for f in raw_gpg/gpg-*; do
        dmtxwrite -ea -o "png_gpg/$(basename "${f}").png" "${f}"
    done

    files=$(find "png_gpg" -iname "gpg-*.png" | wc -l)
    pages=$((files / 35))

    if [ $((files % 35)) -gt 0 ]; then
        pages=$((pages + 1))
    fi

    echo "pages: $pages"

    page_range=$(seq 1 1 "${pages}")
    for num in ${page_range[*]}; do
        echo "num: $num"
        mkdir -v "png_gpg/p${num}"
        find "png_gpg" -iname "gpg-*.png" | head -35 | xargs -I {} mv -v {} "png_gpg/p${num}/."
        montage -verbose -label '%f' -font Helvetica -pointsize 10 -background '#FFFFFF' -fill 'black' -define jpeg:size=240x240 -geometry 240x240+2+2 -tile 5x7 "png_gpg/p${num}/gpg-*.png" "gpg-p${num}.png"
    done
}

make_pages

cat "$2" | gpg --keyid-format 0xlong \
    | convert -background white -size 612x792 -font DejaVu-Sans-Mono \
              -pointsize 10 -gravity northwest -border 24 label:@- title.pdf

convert "title.pdf" "gpg-p*.png" -quality 100 combined.pdf
