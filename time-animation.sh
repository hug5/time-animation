#!/bin/bash
set -u
  # unset/null variables as error
set -e
  # Exit on error


#=============================================================================
#
# Date     : // 2023-12-30;
#          : // 2024-09-16
# File     : time-an.sh or time-animation; put symlink in bin folder;
# Location : /shell-scripts/time-animation
# Website  : xxxxx
# What     : Decorative time display with some animation;
#            - Demonstrate animation without flicker;
#            - Use arrays and random
#            - Top/bottom glyphs' movements correspond to hour/min.
#            -
# License  : GPLv2
# Author   : xxxx <xxx@xxxxx.com>
#
#=============================================================================
    # References:
    # https://www.baeldung.com/linux/monitor-disk-io
    # https://tecadmin.net/iostat-command-in-linux/

    # Ansi characters
    # https://stackoverflow.com/questions/55672661/what-this-character-sequence-033h-033j-does-in-c
    # https://en.wikipedia.org/wiki/ANSI_escape_code
#
#=============================================================================
    # Archive code:
    # https://www.tamasoft.co.jp/en/general-info/unicode.html
    # anim_glyph="—"
    # anim_glyph="⚽"
    # anim_glyph="ⵙ"
    # anim_glyph="|"
    # anim_glyph="ㅡ"
    # anim_glyph="⛻—⭕—❚"
    # anim_glyph="㋨—㋹"  #
    # anim_glyph="◯ㅡ◯"
    # anim_glyph="⚪ㅡ⚪"  #
    # anim_glyph="⃝
    # anim_glyph="●"  #
    # anim_glyph="—————"
    #⋮⋰⋯⋱
    #⎺⎻⎼⎽
    # anim_glyph="⚪ㅡ⚪"
    # ⡮⡯⡰⡱   ⡲   ⡳   ⡴   ⡵   ⡶   ⡷   ⡸   ⡹   ⡺   ⡻   ⡼   ⡽   ⡾   ⡿ ⢀   ⢁   ⢂   ⢃   ⢄   ⢅   ⢆   ⢇   ⢈   ⢉   ⢊   ⢋   ⢌   ⢍   ⢎   ⢏   ⢐   ⢑   ⢒   ⢓   ⢔   ⢕   ⢖   ⢗   ⢘   ⢙   ⢚   ⢛   ⢜   ⢝   ⢞   ⢟ ⢠   ⢡   ⢢   ⢣   ⢤   ⢥   ⢦   ⢧   ⢨   ⢩   ⢪   ⢫   ⢬   ⢭   ⢮   ⢯   ⢰   ⢱   ⢲   ⢳   ⢴   ⢵   ⢶   ⢷   ⢸   ⢹   ⢺   ⢻   ⢼   ⢽   ⢾   ⢿ ⣀   ⣁   ⣂   ⣃   ⣄   ⣅   ⣆   ⣇   ⣈   ⣉   ⣊   ⣋   ⣌   ⣍   ⣎   ⣏   ⣐   ⣑   ⣒   ⣓   ⣔   ⣕   ⣖   ⣗   ⣘   ⣙   ⣚   ⣛   ⣜   ⣝   ⣞   ⣟ ⣠   ⣡   ⣢   ⣣   ⣤   ⣥   ⣦   ⣧   ⣨   ⣩   ⣪   ⣫   ⣬   ⣭   ⣮   ⣯   ⣰   ⣱   ⣲   ⣳   ⣴   ⣵   ⣶   ⣷   ⣸   ⣹   ⣺   ⣻   ⣼   ⣽   ⣾   ⣿

    # anim_glyph="░░"
    # anim_glyph="⭕—⭕"  # This is a real emoji; appears differently in different terminals
    # anim_glyph[0]="▂▄▟██"
    # anim_glyph[1]="███▛"

    #
    # anim_track_spacer_glyph=" "
    # anim_track_spacer_glyph="⛆"
    # anim_track_spacer_glyph="⎕"
    # anim_track_spacer_glyph="░"

    # anim_glyph[0]="████"
    # anim_glyph[1]="████"
#
#=============================================================================
#

# I may have introduced some bugs with the declare and variable types;



declare is_true=true
declare -a loop_counter[0]=0
declare -a loop_counter[1]=0

declare -i sec_unit=1

# How long to sleep between clock microsecond updates
# Divide sec_unit by sec_divisor to get the sleep period
# affects animation velocity;
# sec_divisor=20
declare -i sec_divisor=30
declare sleep_interv  # float
sleep_interv=$( echo "scale=4; $sec_unit/$sec_divisor" | bc )  # float, 4 places
  # Not sure what I'm exactly doing here...
declare adj_real_sec=$(( $sec_unit * $sec_divisor ))  # 30

# 10/13 sets the animation movement; higher number, faster;
# anim_freqency[0]=$(( $adj_real_sec / 6 ))
# anim_freqency[1]=$(( $adj_real_sec / 10 ))
declare anim_freqency[0]=9999
declare anim_freqency[1]=9999


# Animation track length
declare -i anim_length=19

# declare -a anim_track
declare -a anim_track[0]=''
declare -a anim_track[1]=''

declare -a anim_length_counter[0]=1
declare -a anim_length_counter[1]=1

# Denote direction of anim_glyph;
declare -a anim_direction[0]=1
declare -a anim_direction[1]=1

# The animation glyph
# declare -a anim_glyph[0]="▄▄▄▄"

declare -a anim_glyph[0]="████"
declare -a anim_glyph[1]="▀▀▀▀"


# This is "blank" part of the track; but it doesn't
# have to be blank; could also put a glyph here too;
declare anim_track_spacer_glyph=" "

# spinner glyphs to randomly display:
declare -a spinner_glyph_arr=(⡮ ⡯ ⡰ ⡱ ⡲ ⡳ ⡴ ⡵ ⡶ ⡷ ⡸ ⡹ ⡺ ⡻ ⡼ ⡽ ⡾ ⡿ ⢀ \
    ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏ ⢐ ⢑ ⢒ ⢓ ⢔ ⢕ ⢖ ⢗ ⢘ ⢙ \
    ⢚ ⢛ ⢜ ⢝ ⢞ ⢟ ⢠ ⢡ ⢢ ⢣ ⢤ ⢥ ⢦ ⢧ ⢨ ⢩ ⢪ ⢫ ⢬ ⢭ ⢮ ⢯ ⢰ ⢱ ⢲ \
    ⢳ ⢴ ⢵ ⢶ ⢷ ⢸ ⢹ ⢺ ⢻ ⢼ ⢽ ⢾ ⢿ ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ \
    ⣌ ⣍ ⣎ ⣏ ⣐ ⣑ ⣒ ⣓ ⣔ ⣕ ⣖ ⣗ ⣘ ⣙ ⣚ ⣛ ⣜ ⣝ ⣞ ⣟ ⣠ ⣡ ⣢ ⣣ ⣤ \
    ⣥ ⣦ ⣧ ⣨ ⣩ ⣪ ⣫ ⣬ ⣭ ⣮ ⣯ ⣰ ⣱ ⣲ ⣳ ⣴ ⣵ ⣶ ⣷ ⣸ ⣹ ⣺ ⣻ ⣼ ⣽ \
    ⣾ ⣿)

# Start off with this glyph
declare spinner_glyph="${spinner_glyph_arr[0]}"
# echo $spinner_glyph
# sleep(50000)
# spinner_glyph=""


#=============================================================================

function show_help() {
cat << EOF
NAME
    time-animation

DESCRIPTION
    Animated CLI Clock

USAGE
    $ ./time-animation.sh [-r HOUR)] [-m MINUTE] [-h HELP]

EXAMPLE
    $ ./time-animation.sh
      # Default
    $ ./time-animation.sh -r OOOO -m oooo
      # Customize hour and minute glyphs

FLAGS
    -r HOUR       Characters to represent hour.
    -m MINUTE     Characters to represent minute.
    -h            This help.
EOF

}

function unhide_cursor() {
    printf '\e[?25h'
    is_true=false
    echo "";
    echo "exiting..."
    # exit
}

# On exit, I think this runs the given function to unhide the cursor:
# trap unhide_cursor EXIT
function set_unhide_on_exit() {
    trap unhide_cursor SIGINT
}


# Hide cursor
function hide_cursor() {
    printf '\e[?25l'
}

function check_flags() {
    local OPTIND                               # Make this a local; is the index of the next argument index, not current;

    while getopts ":hr:m:" OPTIONS; do
        case "${OPTIONS}" in

          r)
            anim_glyph[0]="${OPTARG}"
            ;;
          m)
            anim_glyph[1]="${OPTARG}"
            ;;
          h)
            show_help; exit;
            ;;
          # \?)
          *)                        # If unknown (any other) option:
            echo "Oops. Unknown option."
            show_help; exit;
            ;;
        esac
    done
}


# Draw the animation for a particular track
function do_animation() {

    local who_id=$1
      # 0 or 1 is passed in
    local i=-1
      # Not sure why -1 works better than zero; with zero, anim_glyph disappears;
    local anim_spacer_char=""
    anim_track[$who_id]=""

    # Not sure what's exactly happening here!

    while [[ $i -le $anim_length ]]; do  # -le: less than or equal
        if [[ $i -eq ${anim_length_counter[$who_id]} ]]; then  # -eq: equal
            anim_spacer_char="${anim_glyph[$who_id]}"
              # The glyph characters
        else
            anim_spacer_char="$anim_track_spacer_glyph"
              # non-glyph spacer; typically space, " "
        fi
        anim_track[$who_id]="${anim_track[$who_id]}${anim_spacer_char}"
          # appending to teh anim_track[] variable in the loop

        # seems both error (with set -e) when i=-1 initially; doesn't like -1!
        # (( i=i+1 ))
        # (( i += 1 )) || true
        (( i++ )) || true
          # using this idiom in order to always return true even when there's error;
          # when set -e is set, it seems that when i is zero,
          # there is an error for whatever reasson;
          # There's other techniques as well;

        # if [[ $i -eq -1 ]]; then
        #     i=0
        # else  # put on 1 line
        #     (( i += 1 ))  # seems this errors (with set -e) when i=-1 initially
        # fi

    done
}

# Randomly select a glyph from glyph array
function set_spinner_glyph() {
    local rand_spinner_index=0
    rand_spinner_index=$(( $RANDOM % ${#spinner_glyph_arr[@]} ))
    spinner_glyph=${spinner_glyph_arr[$rand_spinner_index]}
}

# Set hour/min and respective animation frequency
function set_hour_minute(){

    local who_id=$1
    local hr
    local mn

    if [[ $who_id -eq 0 ]]; then
        hr=$(( $( echo $(date +'%H') | bc) + 1 ))          # hour in 24hrs; +1 to prevent 0 hr;
        # echo $hr
        # local hr=23
        hr=$(echo "scale=2; $hr/2" | bc )                  # scale to 2 decimal places; we want decimals;
        anim_freqency[0]=$(echo "$adj_real_sec/$hr" | bc )  # No scaling; want integer only;
    else
        mn=$(( $(echo $(date +'%M') | bc) + 1 ))           # minutes 00-59; +1 to prevent 0min
        # local mn=30
        mn=$(echo "scale=2; $mn/2" | bc )                  # scale to 2 decimal places; we want decimals;
        anim_freqency[1]=$(echo "$adj_real_sec/$mn" | bc )  # No scaling; want integer only;
    fi
    # echo "${anim_freqency[0]}"
    # echo "${anim_freqency[1]}"

    # I adjust the $hr and $mn variables, dividing by an adjustment factor,
    # So that I can slow down the timing a bit;
    # if number is 08 and try to do something, bash will interpret 08 as
    # an octal and get error; run through bc to remove leading zero; I wanted to
    # add 1 to prevent zero, but it's also causing the octal issue with 08;
}


# Check if the track is supposed to animate
function check_frequency() {

    local who_id=$1
    set_hour_minute $who_id

    if [[ ${loop_counter[$who_id]} -gt ${anim_freqency[$who_id]} ]]; then

        if [[ ${anim_length_counter[$who_id]} -ge $anim_length \
        || ${anim_length_counter[$who_id]} -le -1 ]]; then
        # Why does -le -1 work better than -eq 0 ??? Have to figure this out...

            if [[ ${anim_direction[$who_id]} -eq 0 ]]; then
                anim_direction[$who_id]=1
            else
                anim_direction[$who_id]=0
            fi
        fi

        if [[ ${anim_direction[$who_id]} -eq 1 ]]; then
            (( anim_length_counter[$who_id] += 1 )) || true
        else
            (( anim_length_counter[$who_id] -= 1 )) || true
        fi

        do_animation $who_id
        # change spinner glyph; so obviously, whenever one of the
        # tracks moves, the spinner changes as well;
        set_spinner_glyph
        loop_counter[$who_id]=0
    fi
}

# Initial draw our animation in case the draw frequncy is very low
# and nothing draws for a while
function do_init_setup() {
    clear                 # Clear initial screen
    do_animation 0
    do_animation 1
    set_spinner_glyph
}

function run_animation() {
    # Changed from just true to using a variable == true because it seems
    # that when calling outside the file folder, the program won't exit on ctrl-c;
    # So on ctrl-c interrupt, I set $is_true=false, and that stops the program;
    while [[ $is_true == true ]]; do

        # Move output position to top; rather than successive rows;
        printf '\033[;H'

        echo "$spinner_glyph $(date +'%r +%N')"
        echo "${anim_track[0]}"
        echo -n "${anim_track[1]}"
          # -n : no new line

        (( loop_counter[0] += 1 ))
        (( loop_counter[1] += 1 ))

        # if [[ $i -eq -1 ]]; then

        # set +e
        # (( loop_counter[0]=${loop_counter[0]}+1 ))
        # (( loop_counter[1]=${loop_counter[1]}+1 ))
        # set -e

        check_frequency 0
        check_frequency 1

        sleep $sleep_interv

    done
}

check_flags "$@"
set_unhide_on_exit
hide_cursor
do_init_setup
run_animation

