#!/bin/bash
set -u
  # unset/null variables as error
set -e
  # Exit on error


#=============================================================================
#
# Date     : // 2023-12-30
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
    # ani_glyph="—"
    # ani_glyph="⚽"
    # ani_glyph="ⵙ"
    # ani_glyph="|"
    # ani_glyph="ㅡ"
    # ani_glyph="⛻—⭕—❚"
    # ani_glyph="㋨—㋹"  #
    # ani_glyph="◯ㅡ◯"
    # ani_glyph="⚪ㅡ⚪"  #
    # ani_glyph="⃝
    # ani_glyph="●"  #
    # ani_glyph="—————"
    #⋮⋰⋯⋱
    #⎺⎻⎼⎽
    # ani_glyph="⚪ㅡ⚪"
    # ⡮⡯⡰⡱   ⡲   ⡳   ⡴   ⡵   ⡶   ⡷   ⡸   ⡹   ⡺   ⡻   ⡼   ⡽   ⡾   ⡿ ⢀   ⢁   ⢂   ⢃   ⢄   ⢅   ⢆   ⢇   ⢈   ⢉   ⢊   ⢋   ⢌   ⢍   ⢎   ⢏   ⢐   ⢑   ⢒   ⢓   ⢔   ⢕   ⢖   ⢗   ⢘   ⢙   ⢚   ⢛   ⢜   ⢝   ⢞   ⢟ ⢠   ⢡   ⢢   ⢣   ⢤   ⢥   ⢦   ⢧   ⢨   ⢩   ⢪   ⢫   ⢬   ⢭   ⢮   ⢯   ⢰   ⢱   ⢲   ⢳   ⢴   ⢵   ⢶   ⢷   ⢸   ⢹   ⢺   ⢻   ⢼   ⢽   ⢾   ⢿ ⣀   ⣁   ⣂   ⣃   ⣄   ⣅   ⣆   ⣇   ⣈   ⣉   ⣊   ⣋   ⣌   ⣍   ⣎   ⣏   ⣐   ⣑   ⣒   ⣓   ⣔   ⣕   ⣖   ⣗   ⣘   ⣙   ⣚   ⣛   ⣜   ⣝   ⣞   ⣟ ⣠   ⣡   ⣢   ⣣   ⣤   ⣥   ⣦   ⣧   ⣨   ⣩   ⣪   ⣫   ⣬   ⣭   ⣮   ⣯   ⣰   ⣱   ⣲   ⣳   ⣴   ⣵   ⣶   ⣷   ⣸   ⣹   ⣺   ⣻   ⣼   ⣽   ⣾   ⣿

    # ani_glyph="░░"
    # ani_glyph="⭕—⭕"  # This is a real emoji; appears differently in different terminals
    # ani_glyph[0]="▂▄▟██"
    # ani_glyph[1]="███▛"

    #
    # ani_track_spacer_glyph=" "
    # ani_track_spacer_glyph="⛆"
    # ani_track_spacer_glyph="⎕"
    # ani_track_spacer_glyph="░"

    # ani_glyph[0]="████"
    # ani_glyph[1]="████"
#
#=============================================================================
#


declare true_true=true
declare -a loop_counter[0]=0
declare -a loop_counter[1]=0

declare -i sec_unit=1

# How long to sleep between clock microsecond updates
# Divide sec_unit by sec_divisor to get the sleep period
# sec_divisor=20
declare -i sec_divisor=30
declare sleep_interv; sleep_interv=$( echo "scale=4; $sec_unit/$sec_divisor" | bc )
# sleep_interv=$( echo "scale=4; $sec_unit/$sec_divisor" | bc )

declare -i adj_real_sec=$(( $sec_unit * $sec_divisor ))

# 10/13 sets the animation movement; higher number, faster;
# ani_freqency[0]=$(( $adj_real_sec / 6 ))
# ani_freqency[1]=$(( $adj_real_sec / 10 ))
declare -i ani_freqency[0]=9999
declare -i ani_freqency[1]=9999


# Animation track length
declare -i ani_length=19

declare -a ani_track
declare -a ani_track
# ani_track[0]=''
# ani_track[1]=''

declare -a ani_length_counter[0]=1
declare -a ani_length_counter[1]=1

# Denote direction of ani_glyph;
declare -a ani_direction[0]=1
declare -a ani_direction[1]=1

# The animation glyph
# declare -a ani_glyph[0]="▄▄▄▄"

declare -a ani_glyph[0]="████"
declare -a ani_glyph[1]="▀▀▀▀"

# This is "blank" part of the track; but it doesn't
# have to be blank; could also put a glyph here too;
declare ani_track_spacer_glyph=" "

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

function unhide_cursor() {
    printf '\e[?25h'
    true_true=false
    echo "";
    echo "exiting..."
    # exit
}

# Draw the animation for a particular track
function do_animation() {

    local who_id=$1
    local i=-1  # Not sure why -1 works better than zero; with zero, ani_glyph disappears;
    local ani_spacer_char=""
    ani_track[$who_id]=""

    while [[ $i -le $ani_length ]]; do  # -le: less than or equal
        if [[ $i -eq ${ani_length_counter[$who_id]} ]]; then  # -eq: equal
            ani_spacer_char="${ani_glyph[$who_id]}"
        else
            ani_spacer_char="$ani_track_spacer_glyph"
        fi
        ani_track[$who_id]="${ani_track[$who_id]}${ani_spacer_char}"

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


function set_hour_minute(){

    # The set -e problem seems to be hanging here:
    local who_id=$1
    local hr
    local mn

    if [[ $who_id -eq 0 ]]; then
        hr=$(( $( echo $(date +'%H') | bc) + 1 ))   # hour in 24hrs; +1 to prevent 0 hr;
        # local hr=23
        hr=$(echo "scale=2; $hr/2" | bc )           # scale to 2 decimal places; we want decimals;
        ani_freqency[0]=$(echo "$adj_real_sec/$hr" | bc ) # No scaling; want integer only;
    else
        mn=$(( $(echo $(date +'%M') | bc) + 1 ))    # minutes 00-59; +1 to prevent 0min
        # local mn=30
        mn=$(echo "scale=2; $mn/2" | bc )           # scale to 2 decimal places; we want decimals;
        ani_freqency[1]=$(echo "$adj_real_sec/$mn" | bc ) # No scaling; want integer only;
    fi

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

    if [[ ${loop_counter[$who_id]} -gt ${ani_freqency[$who_id]} ]]; then

        if [[ ${ani_length_counter[$who_id]} -ge $ani_length ||
              ${ani_length_counter[$who_id]} -le 0 ]]; then

            if [[ ${ani_direction[$who_id]} -eq 0 ]]; then
                ani_direction[$who_id]=1
            else
                ani_direction[$who_id]=0
            fi
        fi

        # set +e
        if [[ ${ani_direction[$who_id]} -eq 1 ]]; then
            (( ani_length_counter[$who_id] += 1 )) || true
        else
            (( ani_length_counter[$who_id] -= 1 )) || true
        fi
        # set -e

        do_animation $who_id
        # change spinner glyph; so obviously, whenever one of the
        # tracks moves, the spinner changes as well;
        set_spinner_glyph
        loop_counter[$who_id]=0
    fi
}

# On exit, I think this runs the given function to unhide the cursor:
# trap unhide_cursor EXIT
trap unhide_cursor SIGINT
# Hide cursor
printf '\e[?25l'

# Clear screen
clear

# predraw our animation in case the draw frequncy is very low
# and nothing draws for a while
do_animation 0
do_animation 1
set_spinner_glyph

# Changed from just true to using a variable == true because it seems
# that when calling outside the file folder, the program won't exit on ctrl-c;
# So on ctrl-c interrupt, I set $true_true=false, and that stops the program;
while [[ $true_true == true ]]; do

    # Move position to top
    printf '\033[;H'

    echo "$spinner_glyph $(date +'%r +%N')"
    echo "${ani_track[0]}"
    echo -n "${ani_track[1]}"

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

