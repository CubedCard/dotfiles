#!/usr/bin/env bash
# Rectangle-style window snapping. Usage: rectangle.sh <action>
# Actions: left right top bottom tl tr bl br first-third center-third last-third
#          first-two-thirds last-two-thirds maximize center restore smaller larger
set -euo pipefail

action=$1
state_dir=${XDG_RUNTIME_DIR:-/tmp}/rectangle
mkdir -p "$state_dir"

win=$(hyprctl activewindow -j)
[[ $(jq -r '.address // empty' <<<"$win") ]] || exit 0
addr=$(jq -r '.address' <<<"$win")
floating=$(jq -r '.floating' <<<"$win")
read -r wx wy ww wh < <(jq -r '"\(.at[0]) \(.at[1]) \(.size[0]) \(.size[1])"' <<<"$win")

mon=$(hyprctl monitors -j | jq --argjson id "$(jq '.monitor' <<<"$win")" '.[] | select(.id == $id)')
read -r mx my mw mh < <(jq -r '
  (.width / .scale | floor) as $w | (.height / .scale | floor) as $h |
  "\(.x + .reserved[0]) \(.y + .reserved[1]) \($w - .reserved[0] - .reserved[2]) \($h - .reserved[1] - .reserved[3])"' <<<"$mon")

dispatch() { hyprctl dispatch "$1" >/dev/null; }

place() { # x y w h (absolute)
  dispatch 'hl.dsp.window.float({action="enable"})'
  dispatch "hl.dsp.window.resize({x=$3,y=$4,exact=true})"
  dispatch "hl.dsp.window.move({x=$1,y=$2,exact=true})"
}

frac() { # fx fy fw fh as fractions of the usable area
  place "$(awk "BEGIN{printf \"%d\", $mx+$mw*$1}")" "$(awk "BEGIN{printf \"%d\", $my+$mh*$2}")" \
        "$(awk "BEGIN{printf \"%d\", $mw*$3}")" "$(awk "BEGIN{printf \"%d\", $mh*$4}")"
}

is_at() { # fx fy fw fh: does the window already occupy this fraction of the area?
  awk -v a="$wx $wy $ww $wh" -v m="$mx $my $mw $mh" -v f="$1 $2 $3 $4" 'BEGIN{
    split(a,A," "); split(m,M," "); split(f,F," ");
    ok = (A[1]-(M[1]+M[3]*F[1]))^2 < 16 && (A[2]-(M[2]+M[4]*F[2]))^2 < 16 &&
         (A[3]-M[3]*F[3])^2 < 16 && (A[4]-M[4]*F[4])^2 < 16;
    exit !ok}'
}

# Repeated presses cycle through the given fractions (half -> two thirds -> one third)
cycle() {
  local n=$(($# / 4)) i
  for ((i = 0; i < n; i++)); do
    if [[ $floating == true ]] && is_at "${@:i*4+1:4}"; then
      local j=$(((i + 1) % n))
      frac "${@:j*4+1:4}"
      return
    fi
  done
  frac "${@:1:4}"
}

if [[ $action == restore ]]; then
  [[ -f $state_dir/$addr ]] || exit 0
  read -r x y w h f <"$state_dir/$addr"
  if [[ $f == false ]]; then
    dispatch 'hl.dsp.window.float({action="disable"})'
  else
    place "$x" "$y" "$w" "$h"
  fi
  rm -f "$state_dir/$addr"
  exit 0
fi

echo "$wx $wy $ww $wh $floating" >"$state_dir/$addr.new"
[[ -f $state_dir/$addr ]] || mv "$state_dir/$addr.new" "$state_dir/$addr"
rm -f "$state_dir/$addr.new"

case $action in
  left)             cycle 0 0 0.5 1  0 0 0.6666667 1  0 0 0.3333333 1 ;;
  right)            cycle 0.5 0 0.5 1  0.3333333 0 0.6666667 1  0.6666667 0 0.3333333 1 ;;
  top)              frac 0 0 1 0.5 ;;
  bottom)           frac 0 0.5 1 0.5 ;;
  tl)               frac 0 0 0.5 0.5 ;;
  tr)               frac 0.5 0 0.5 0.5 ;;
  bl)               frac 0 0.5 0.5 0.5 ;;
  br)               frac 0.5 0.5 0.5 0.5 ;;
  first-third)      frac 0 0 0.3333333 1 ;;
  center-third)     frac 0.3333333 0 0.3333333 1 ;;
  last-third)       frac 0.6666667 0 0.3333333 1 ;;
  first-two-thirds) frac 0 0 0.6666667 1 ;;
  last-two-thirds)  frac 0.3333333 0 0.6666667 1 ;;
  maximize)         frac 0 0 1 1 ;;
  center)
    place "$((mx + (mw - ww) / 2))" "$((my + (mh - wh) / 2))" "$ww" "$wh" ;;
  smaller|larger)
    step=$((mw / 20)); [[ $action == smaller ]] && step=$((-step))
    stepy=$((mh / 20)); [[ $action == smaller ]] && stepy=$((-stepy))
    place "$((wx - step / 2))" "$((wy - stepy / 2))" "$((ww + step))" "$((wh + stepy))" ;;
  *) echo "unknown action: $action" >&2; exit 1 ;;
esac
