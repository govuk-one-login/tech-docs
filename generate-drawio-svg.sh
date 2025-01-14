#!/bin/bash

source_dir="source/images/originals"
dest_dir="source/images"

for file in "$source_dir"/*; do
    filename=$(basename "$file" .drawio)
    dest_file="$dest_dir/$filename.svg"

    /Applications/draw.io.app/Contents/MacOS/draw.io -x -o "$dest_file" "$file"
done
