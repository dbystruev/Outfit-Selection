find . -name '*.strings' -exec grep -o '".*"' {} \; | cut -d\" -f4 | sort -u
