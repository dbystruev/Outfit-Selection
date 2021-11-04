find . -name '*.swift' -exec grep -o '".*"' {} \; | sort -u
