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

$ ./time-animation.sh -o [--] -m [__]     

⣍ 10:41:12 PM +899305553
              [--]
     [__]     
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
    $ ./time-animation.sh -o [--] -m [__]
      # Customize hour and minute glyphs

FLAGS
    -o HOUR       Characters to represent hour. 23 chars max.
    -m MINUTE     Characters to represent minute. 23 chars max.
    -h            This help.

```          


