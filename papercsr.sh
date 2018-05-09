#!/usr/bin/env bash

split -b 128 - csr-  < "$1"

function make_pages () {
    mkdir -vp "raw_$1"
    mkdir -vp "png_$1"
    mv -v "${1}"-* "raw_${1}/."

    for f in raw_$1/$1-*; do
        dmtxwrite -ea -o "png_$1/$(basename "${f}").png" "${f}"
    done

    files=$(find "png_$1" -iname "$1-*.png" | wc -l)
    pages=$((files / 35))

    if [ $((files % 35)) -gt 0 ]; then
        pages=$((pages + 1))
    fi

    page_range=$(seq 1 1 "${pages}")
    for n in "${page_range[@]}"; do
        mkdir -v "png_$1/p${n}"
        find "png_$1" -iname "$1-*.png" | head -35 | xargs -I {} mv -v {} "png_$1/p${n}/."
        montage -verbose -label '%f' -font Helvetica -pointsize 10 -background '#FFFFFF' -fill 'black' -define jpeg:size=240x240 -geometry 240x240+2+2 -tile 5x7 "png_$1/p${n}/$1-*.png" "$1-p${n}.png"
    done
}

make_pages "csr"

openssl req -in "$1" -text -noout -reqopt no_pubkey,no_sigdump \
    | convert -background white -size 612x792 -font DejaVu-Sans-Mono \
              -pointsize 12 -gravity northwest -border 24 label:@- title.pdf

convert "title.pdf" "csr-p*.png" -quality 100 "$(echo "$1" | sed 's/\.csr//')-combined.pdf"
