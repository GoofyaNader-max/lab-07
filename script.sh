for tc in Testcase1 Testcase2 Testcase3 Testcase4; do
    diffdir="${tc}Diff"
    rm -rf "$diffdir"

    for f1 in "$tc"/*.1.txt; do
	[ -e "$f1" ] || continue
	base=$(basename "$f1" .1.txt)
	f2="${tc}/${base}.2.txt"
	[ -e "$f2" ] || continue

	outfile="/tmp/${base}.diff.$$"
	diff -u "$f1" "$f2" > "$outfile"

	if [ -s "$outfile" ]; then
	    mkdir -p "$diffdir"
	    mv "$outfile" "$diffdir/${base}Diff.txt"
	else
	    rm -f "$outfile"
	fi
    done
done 
