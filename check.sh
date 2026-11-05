overall_status=0

for tc in Testcase1 Testcase2 Testcase3 Testcase4; do
    diffdir="${tc}Diff"
    tc_ok=1
    any_diff=0

    for f1 in "$tc"/*.1.txt; do
	[ -e "$f1" ] || continue
	base=$(basename "$f1" .1.txt)
	f2="${tc}/${base}.2.txt"
	[ -e "$f2" ] || continue

	outfile="${diffdir}/${base}Diff.txt"

	if cmp -s "$f1" "$f2"; then
	    if [ -f "$outfile" ]; then
		echo "unexpected $outfile for identical pair" >&2
		tc_ok=0
	    fi
	else
	    any_diff=1
	    if [ ! -f "$outfile" ]; then
		echo "missing $outfile" >&2
		tc_ok=0
	    else
		expected=$(diff -u "$f1" "$f2" | tail -n +3)
		actual=$(tail -n +3 "$outfile")
		if [ "$expected" != "$actual" ]; then
		    echo "content mismatch in $outfile" >&2
		    tc_ok=0
		fi
	    fi
	fi
    done

    if [ "$any_diff" -eq 1 ]; then
	if [ ! -d "$diffdir" ]; then
	    echo "missing directory $diffdir" >&2
	    tc_ok=0;
	fi
    else
        if [ -d "$diffdir" ]; then
	    echo "unexpected directory $diffdir" >&2
	    tc_ok=0
	fi
    fi

    if [ "$tc_ok" -eq 1 ]; then
	echo "${tc}: PASS"
    else
	echo "${tc}: FAIL"
	overall_status=1
    fi
done

exit $overall_status
    
