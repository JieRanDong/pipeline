#!/bin/bash
# get file rank
files=( $(ls MA*.meme | sort -V) )

# check
if [ ${#files[@]} -eq 0 ]; then
    echo "empty"
    exit 1
fi

# remove the first 9 lines
for ((i=1; i<${#files[@]}-1; i++)); do
    tail -n +10 "${files[i]}" > tmp && mv tmp "${files[i]}"
done

rm -f tmp