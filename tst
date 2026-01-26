#!/bin/bash
set -eu
for i in ~/.config/PrusaSlicer/{printer,filament,print}/*.ini; do
	t=$(basename $(dirname "$i"))
	x=$(basename "${i%.ini}")
	case "$x" in
		*@MK3*) continue ;;
	esac
	NAME="$t:${x%" - "?"."?"."?}"
	echo "[tst]" "$NAME" "=?" "$i"
	./parseprusa.py voron.ini "$NAME" | tail -n +2 | diff -u <(tail -n +2 "$i") -
done
echo All tests passed.
