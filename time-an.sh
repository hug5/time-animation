#!/bin/bash

# // 2023-12-30
# References:
# https://www.baeldung.com/linux/monitor-disk-io
# https://tecadmin.net/iostat-command-in-linux/

# Ansi characters
# https://stackoverflow.com/questions/55672661/what-this-character-sequence-033h-033j-does-in-c
# https://en.wikipedia.org/wiki/ANSI_escape_code


#----------------------------------------------------------

## Variables
LOOP_COUNTER[0]=0
LOOP_COUNTER[1]=0

SEC=1
DIVISOR=20  # Divide SEC by DIVISOR to get the sleep period
SLEEPTIME_INTERVAL=$( echo "scale=3; $SEC/$DIVISOR" | bc )

REAL_SEC=$(( $SEC * $DIVISOR ))

FREQUENCY[0]=$(( $REAL_SEC / 10 ))
FREQUENCY[1]=$(( $REAL_SEC / 13 ))

SPACE[0]=''
SPACE[1]=''

WALKLENGTH=18

WALKLENGTH_COUNTER[0]=1
WALKLENGTH_COUNTER[1]=1

DIRECTION[0]=1  # forward/backward
DIRECTION[1]=1  # forward/backward

GLYPH='⡮'


#----------------------------------------------------------


# https://www.tamasoft.co.jp/en/general-info/unicode.html
    # EMOJI="—"
    # EMOJI="⚽"
    # EMOJI="ⵙ"
    # EMOJI="|"
    # EMOJI="ㅡ"
    # EMOJI="⛻—⭕—❚"
    # EMOJI="㋨—㋹"  #
    # EMOJI="◯ㅡ◯"
    # EMOJI="⚪ㅡ⚪"  #
    # EMOJI="⃝
    # EMOJI="●"  #
    # EMOJI="—————"
    #⋮⋰⋯⋱
    #⎺⎻⎼⎽
    # EMOJI="⚪ㅡ⚪"
    # ⡮⡯⡰⡱   ⡲   ⡳   ⡴   ⡵   ⡶   ⡷   ⡸   ⡹   ⡺   ⡻   ⡼   ⡽   ⡾   ⡿ ⢀   ⢁   ⢂   ⢃   ⢄   ⢅   ⢆   ⢇   ⢈   ⢉   ⢊   ⢋   ⢌   ⢍   ⢎   ⢏   ⢐   ⢑   ⢒   ⢓   ⢔   ⢕   ⢖   ⢗   ⢘   ⢙   ⢚   ⢛   ⢜   ⢝   ⢞   ⢟ ⢠   ⢡   ⢢   ⢣   ⢤   ⢥   ⢦   ⢧   ⢨   ⢩   ⢪   ⢫   ⢬   ⢭   ⢮   ⢯   ⢰   ⢱   ⢲   ⢳   ⢴   ⢵   ⢶   ⢷   ⢸   ⢹   ⢺   ⢻   ⢼   ⢽   ⢾   ⢿ ⣀   ⣁   ⣂   ⣃   ⣄   ⣅   ⣆   ⣇   ⣈   ⣉   ⣊   ⣋   ⣌   ⣍   ⣎   ⣏   ⣐   ⣑   ⣒   ⣓   ⣔   ⣕   ⣖   ⣗   ⣘   ⣙   ⣚   ⣛   ⣜   ⣝   ⣞   ⣟ ⣠   ⣡   ⣢   ⣣   ⣤   ⣥   ⣦   ⣧   ⣨   ⣩   ⣪   ⣫   ⣬   ⣭   ⣮   ⣯   ⣰   ⣱   ⣲   ⣳   ⣴   ⣵   ⣶   ⣷   ⣸   ⣹   ⣺   ⣻   ⣼   ⣽   ⣾   ⣿

    # EMOJI="░░"
    # EMOJI="⭕—⭕"  # This is a real emoji; appears differently in different terminals
    # EMOJI[0]="▂▄▟██"
    # EMOJI[1]="███▛"

EMOJI[0]="████"
EMOJI[1]="████"



#
    # SPACER=" "
    # SPACER="⛆"
    # SPACER="⎕"
    # SPACER_TRACK="░"
SPACER_TRACK=" "

SPINNER_ARR=(⡮ ⡯ ⡰ ⡱ ⡲ ⡳ ⡴ ⡵ ⡶ ⡷ ⡸ ⡹ ⡺ ⡻ ⡼ ⡽ ⡾ ⡿ ⢀ ⢁ ⢂ ⢃ ⢄ ⢅ ⢆ ⢇ ⢈ ⢉ ⢊ ⢋ ⢌ ⢍ ⢎ ⢏ ⢐ ⢑ ⢒ ⢓ ⢔ ⢕ ⢖ ⢗ ⢘ ⢙ ⢚ ⢛ ⢜ ⢝ ⢞ ⢟ ⢠ ⢡ ⢢ ⢣ ⢤ ⢥ ⢦ ⢧ ⢨ ⢩ ⢪ ⢫ ⢬ ⢭ ⢮ ⢯ ⢰ ⢱ ⢲ ⢳ ⢴ ⢵ ⢶ ⢷ ⢸ ⢹ ⢺ ⢻ ⢼ ⢽ ⢾ ⢿ ⣀ ⣁ ⣂ ⣃ ⣄ ⣅ ⣆ ⣇ ⣈ ⣉ ⣊ ⣋ ⣌ ⣍ ⣎ ⣏ ⣐ ⣑ ⣒ ⣓ ⣔ ⣕ ⣖ ⣗ ⣘ ⣙ ⣚ ⣛ ⣜ ⣝ ⣞ ⣟ ⣠ ⣡ ⣢ ⣣ ⣤ ⣥ ⣦ ⣧ ⣨ ⣩ ⣪ ⣫ ⣬ ⣭ ⣮ ⣯ ⣰ ⣱ ⣲ ⣳ ⣴ ⣵ ⣶ ⣷ ⣸ ⣹ ⣺ ⣻ ⣼ ⣽ ⣾ ⣿)



#----------------------------------------------------------

function unhide_cursor() {
    printf '\e[?25h'
}

function do_animation() {
    local WHOID=$1
    local i=-1  # Not sure why -1 works better than zero; with zero, emoji disappears;
    local SPACER=""
    SPACE[$WHOID]=""

    while [[ "$i" -le "$WALKLENGTH" ]]; do  # -le=less than or equal
        if [[ $i -eq ${WALKLENGTH_COUNTER[$WHOID]} ]]; then
            SPACER="${EMOJI[$WHOID]}"
        else
            SPACER="$SPACER_TRACK"
        fi
        SPACE[$WHOID]="${SPACE[$WHOID]}${SPACER}"
        (( i += 1 ))
    done
}

function set_glyph() {
    local RAND=0
    # RAND=$[$RANDOM % ${#SPINNER_ARR[@]}]
    RAND=$(( $RANDOM % ${#SPINNER_ARR[@]} ))
    GLYPH=${SPINNER_ARR[$RAND]}
}

function check_frequency() {

    local WHOID=$1

    if [[ ${LOOP_COUNTER[$WHOID]} -gt ${FREQUENCY[$WHOID]} ]]; then

        if [[ ${WALKLENGTH_COUNTER[$WHOID]} -ge $WALKLENGTH || ${WALKLENGTH_COUNTER[$WHOID]} -le 0 ]]; then
            if [[ ${DIRECTION[$WHOID]} -eq 0 ]]; then
                DIRECTION[$WHOID]=1
            else
                DIRECTION[$WHOID]=0
            fi
        fi

        if [[ ${DIRECTION[$WHOID]} -eq 1 ]]; then
            (( WALKLENGTH_COUNTER[$WHOID] += 1 ))
        else
            (( WALKLENGTH_COUNTER[$WHOID] -= 1 ))
        fi
        # do_animation $WALKLENGTH_COUNTER
        do_animation $WHOID
        set_glyph
        LOOP_COUNTER[$WHOID]=0
    fi
}

# On exit, I think this runs the given function to unhide the cursor:
# trap unhide_cursor EXIT
trap unhide_cursor SIGINT
# Hide cursor
printf '\e[?25l'

# Clear screen
clear

while [[ true ]]; do


    # Move position to top
    printf '\033[;H'

    echo "${SPACE[0]}"
    echo "$GLYPH $(date +'%r +%N')"
    echo -n "${SPACE[1]}"

    (( LOOP_COUNTER[0] += 1 ))
    (( LOOP_COUNTER[1] += 1 ))

    check_frequency 0
    check_frequency 1

    # if [[ $LOOP_COUNTER -gt $FREQUENCY ]]; then

    #     if [[ $WALKLENGTH_COUNTER -ge $WALKLENGTH || $WALKLENGTH_COUNTER -le 0 ]]; then
    #         if [[ $DIRECTION -eq 0 ]]; then
    #             DIRECTION=1
    #         else
    #             DIRECTION=0
    #         fi
    #     fi

    #     if [[ $DIRECTION -eq 1 ]]; then
    #         (( WALKLENGTH_COUNTER += 1 ))
    #     else
    #         (( WALKLENGTH_COUNTER -= 1 ))
    #     fi
    #     # do_animation $WALKLENGTH_COUNTER
    #     do_animation
    #     set_glyph
    #     LOOP_COUNTER=0

    # fi

    sleep $SLEEPTIME_INTERVAL

done

