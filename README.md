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

$ ./time-animation.sh -o '[--]' -m '<o0o>'     

⣍ 10:41:12 PM +899305553
              [--]
     <o0o>     
```          
     
     
```
$ time-animation -h

NAME
    time-animation

DESCRIPTION
    Animated CLI Clock

USAGE
    $ ./time-animation.sh [-o HOUR)] [-m MINUTE] [-h HELP]

EXAMPLE
    $ ./time-animation.sh
      # Default
    $ ./time-animation.sh -o '[--]' -m '<o0o>'
      # Customize hour and minute glyphs

FLAGS
    -o HOUR       Characters to represent hour.
    -m MINUTE     Characters to represent minute. 
    -h            This help.

```          


