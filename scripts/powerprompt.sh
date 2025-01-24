#!/usr/bin/env bash

STYLES_FILE="$HOME/.powerprompt/styles.sh"
CONFIG_FILE="$HOME/.powerprompt/prompt_config.conf"

bg_file="$HOME/.powerprompt/.bg_color"

if [ -f "$STYLES_FILE" ]; then
  source "$STYLES_FILE"
else
  echo "Styles file not found: $STYLES_FILE. Using default values"
fi

if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
else
  echo "Configuration file not found: $CONFIG_FILE. Using default values"
fi

: Penguin=$'\U1f427'
: Triangle_powerline=$'\ue0b0'
: Triangle=$'\U1fb6c'

: PATH_DISPLAY='segments'
: PROMPT_SYMBOL='$'
: HOSTNAME_BG_COLOR='27'
: HOSTNAME_FG_COLOR='15'
: HOST_ICON=$penguin
: CLOCK_BG_COLOR='52'
: CLOCK_FG_COLOR='51'
: CLOCK_ICON=$'\U1f551'
: FONT_COLOR='\e[0;38;5;137m'
: PATH_ICON=$'\U1f5c1'        # open folder
: STATUS_BG_COLOR='123'
: STATUS_FG_COLOR='236'
: STATUS_SUCCESS='\U2714'
: STATUS_FAILURE='\U2717'
: SEGMENT_SEPARATOR=$Triangle

italic='\[\e[3m\]'


if [ ! -f "$bg_file" ]; then
  echo 0 > "$bg_file"
fi

color_reset='\[\e[00m\]'

function reset_bg_file {
  echo 0 > "$bg_file"
}

function color { # fg bg
  printf "\[\e[1;38;5;$1;48;5;$2m\]"
}
  
function segment { 
  local fg=$1 bg=$2 txt=$3
  lastbg=$(cat "$bg_file")
  : lastbg=0

  local seg=""
  if [[ lastbg -gt 0 ]]; then
    seg+="$(color $lastbg $bg)$SEGMENT_SEPARATOR$color_reset"
  fi
  seg+="$(color $fg $bg)$txt$color_reset"
  echo "$bg" > "$bg_file"
  echo -e "$seg"
}
  
function exit_code {
  if [[ $1 -eq 0 ]]; then
    echo -e $STATUS_SUCCESS; return
  fi
  echo -e $STATUS_FAILURE' '$1
}

function colored_path {
  local old_ifs="$IFS"
  IFS="/"
  local path_segments=$(segment 16 40 $PATH_ICON'  ')
  #local lastbg=40
  local color_arr=(27 130 28 133)
  local p=$1
  if [[ "$p" == "$HOME"* ]]; then
    p="~${p#$HOME}"
  fi
  local index=0
  for i in ${p[@]}; do
    if [[ -n "$i" ]]; then
      bg="${color_arr[$index]}"
      local path_segments+=$(segment 16 $bg " $i ")
      (( index=(index + 1) % ${#color_arr[@]} ))
    fi
  done
  IFS="$old_ifs"
  printf "$path_segments"
}

function seg_status {
  echo -e "$(segment $STATUS_FG_COLOR $STATUS_BG_COLOR '[$(exit_code $?)]')"
}
    

function seg_machine {
  echo -e "$(segment $HOSTNAME_FG_COLOR $HOSTNAME_BG_COLOR $HOST_ICON'''\u@\h:')"
}

function seg_clock {
  echo -e "$(segment $CLOCK_FG_COLOR $CLOCK_BG_COLOR ' '$CLOCK_ICON' \T ')"
}

function seg_path {
  echo -e "$(segment $PATH_FG_COLOR $PATH_BG_COLOR ' '$PATH_ICON' '$italic' \w ')"
}

if [ "$PATH_DISPLAY" = 'segments' ]; then
  PROMPT_COMMAND='$(reset_bg_file); PS1="${debian_chroot:+($debian_chroot)}$(seg_machine)$(seg_clock)$(colored_path "$PWD")$(seg_status) \$PROMPT_SYMBOL\[$FONT_COLOR\] "'
else
  italic='\[\e[3m\]'
  seg_st=$(segment $STATUS_FG_COLOR $STATUS_BG_COLOR '[$(exit_code $?)]')
  reset_bg_file
  PS1="${debian_chroot:+($debian_chroot)}$(seg_machine)$(seg_clock)$(seg_path)$seg_st \$PROMPT_SYMBOL\[$FONT_COLOR\] "
fi


