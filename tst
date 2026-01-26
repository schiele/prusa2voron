#!/bin/bash
set -eu
tstdir=$(mktemp -d)
trap "rm -rf $tstdir" EXIT
./parseprusa.py voron.ini "$tstdir="
for i in ~/.config/PrusaSlicer/{printer,filament,print}/*.ini; do
	t=$(basename $(dirname "$i"))
	x=$(basename "${i%.ini}")
	case "$x" in
		*@MK3*) continue ;;
	esac
	NAME="$t:${x%" - "?"."?"."?}"
	echo "[tst]" "$NAME" "=?" "$i"
	diff -u <(tail -n +2 "$i") <(tail -n +2 "$tstdir/$t/${x%" - "?"."?"."?}".ini)
done
echo All tests passed.
