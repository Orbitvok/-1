#!/bin/bash

directory="${1:-.}"

cd "$directory"

for file in *.jpg; do
	if [[ -f "$file" ]]; then
		output_file="${file%.jpg}.jp2"
		convert -verbose "$file" -quality 100 "$output_file"
	fi
done

echo "Done"

