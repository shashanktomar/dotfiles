#!/usr/bin/env zsh

VOLUME="${INFO:-$(osascript -e 'set ovol to output volume of (get volume settings)')}"

case ${VOLUME} in
0)
  ICON="􀊢"
  ICON_PADDING_RIGHT=21
  ;;
[0-9])
  ICON="􀊤"
  ICON_PADDING_RIGHT=12
  ;;
*)
  ICON="􀊩"
  ICON_PADDING_RIGHT=6
  ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT label="$VOLUME%"
