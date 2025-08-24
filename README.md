# Time-Animation

Animated CLI Clock for your terminal.
- Upper glyph represents the hour hand.
- The lower glyph represents the minute hand.
- Hour/minute glyphs can be customized.
- Glyphs animate proportional to its time.
- Not required, but best used in a Tmux pane.

```
$ ./time-animation.sh

⢳ 09:34:59 PM +776797245
  ████
          ▀▀▀▀

$ ./time-animation.sh -o '[--]' -m '<o=o>'     

⣍ 10:41:12 PM +899305553
              [--]
     <o=o>     
```          
     
     
```
$ time-animation -h

NAME
    time-animation

DESCRIPTION
    Animated CLI Clock

USAGE
    $ ./time-animation.sh [-g 0-N] [-o HOUR)] [-m MINUTE] [-h HELP]

EXAMPLE
    $ ./time-animation.sh
      # Randomly selects one of built in glyphs
    $ ./time-animation.sh -o '[--]' -m '<o0o>'
      # Customize hour and minute glyphs
    $ ./time-animation.sh -g1
      # Use one of the pre-built optional glyphs; 0 to N;

FLAGS
    -o HOUR glyph      Characters to represent hour.
    -m MINUTE glyph    Characters to represent minute.
    -g Pre-built       0-N; Use one of the prebuilt glyphs.
    -h                 This help.
EOF

```          


