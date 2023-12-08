# Theme-Buffet for GNU Emacs

The theme-buffet package arranges to automatically change themes during specific
times of the day or at fixed intervals. The collection of themes is
customisable, with the default options covering the built-in Emacs themes as
well as Prot's modus-themes and ef-themes.

Protesilaos "Prot" Stavrou is the co-maintainer.

+ Package name (GNU ELPA): `theme-buffet`
+ Git repo on SourceHut: <https://git.sr.ht/~bboal/theme-buffet>
+ Mailing list: <https://lists.sr.ht/~bboal/general-issues>
+ Backronym: Themes Harmoniously Exchanged Mid Evening Beget Understandable
  Feelings of Fascination, Excitement, and Thrill.



## Installation

Theme-Buffet is on GNU ELPA, so it can be installed using `M-x package-install` and
then searching for `theme-buffet`.

Another option is evaluating the following:

``` emacs-lisp
    (unless (package-installed-p 'theme-buffet)
      (unless package-archive-contents
        (package-refresh-contents))
      (package-install 'theme-buffet)
      (require 'theme-buffet))
```


Or using the macro `use-package`, while combining some settings explained
in the *Usage* section:

``` emacs-lisp
    (use-package theme-buffet
      :after (modus-themes ef-themes)  ; add your favorite themes here
      :init
      ;; variable below needs to be set when you just want to use the timers mins/hours
      (setq theme-buffet-menu 'modus-ef) ; changing default value from built-in to modus-ef
      :config
      ;;; one of the three below can be uncommented
      ;; (theme-buffet-modus-ef)
      ;; (theme-buffet-built-in)
      ;; (theme-buffet-end-user)
      ;;; two additional timers are available for theme change, both can be set
      (theme-buffet-timer-mins 25)  ; change theme every 25m from now, similar below
      (theme-buffet-timer-hours 2))
```


You can also clone this repository, add the path to the
load-path variable and then require the library. Here's an example:

### In the terminal:

``` shell
    git clone https://git.sr.ht/~bboal/theme-buffet ~/.emacs.d/theme-buffet
```

##### Then, in Emacs, evaluate:

```emacs-lisp
    (add-to-list 'load-path "~/.emacs.d/theme-buffet")
    (require 'theme-buffet)
```



## Settings and customization

There are three templates pre-configured available for usage. One enabled by
default (built-in), with the standard themes that come with vanilla Emacs; the
other (modus-ef), more fancier, uses a combination of the Modus themes and Ef
themes, both authored by Protesilaos "Prot" Stavrou
<https://git.sr.ht/~protesilaos>, distributed across six periods of the day
(night, twilight, morning, day, afternoon and evening). And the last (end-user),
is merely a copy of the default, meant to be changed and tweaked by the user.  A
personal configuration can be achieved by tweaking the
`theme-buffet-end-user`. For inspiration, take a look at
`theme-buffet--modus-ef` which is used when setting `theme-buffet-menu` to
'modus-ef like demonstrated below.

``` emacs-lisp
(setq theme-buffet-menu 'modus-ef)  ;; other options are 'built-in and 'end-user
```


Following the appanage way of Emacs, the names and the number of themes and time
periods can be freely changed while maintaining the same structure. There is
also a time-offset that can be set by the user to match a specific
time-zone/personal preference.  E.g.

``` emacs-lisp
    (setq theme-buffet-time-offset 2)
```


### Notes

+ This package will not install neither the Modus nor the Ef themes.  It will be
the responsibility of the user to install those or any other themes. Refer to
the repository of the chosen themes for more information.

+ Setting the `theme-buffet-menu` variable and activating the minor mode by
evaluating:

``` emacs-lisp
    (theme-buffet-mode 1)
```

will not accomplish nothing by itself. The variable setting only tells
Theme-Buffet which themes should be used in the event of the user NOT opting-in
for loading the themes when the time periods change, but rather in a defined
time period, using the functions `theme-buffet-timer-mins` or
`theme-buffet-timer-hours` like demonstrated below.

+ Contrarly if the user chooses to have the themes load at period change by using
one of the functions for that effect (`theme-buffet-built-in`,
`theme-buffet-modus-ef` or `theme-buffet-end-user`), this variable is set automatically.



## Usage:

There are several interactive functions available to the user serving as entry
points to the package.

To set the menu for the desired themes property list and have the themes
change when the periods do, evaluate or use `M-x` on ONE of the following:

``` emacs-lisp
    (theme-buffet-built-in)
    ;; or
    (theme-buffet-modus-ef)
    ;; or
    (theme-buffet-end-user)
```

When evaluating or executing any of the above functions, the `theme-buffet-menu`
variable is set accordingly.


To set the timer for a certain time interval of hours or minutes, E.g. Every 45
minutes and also every 2h from now:

``` emacs-lisp
    (theme-buffet-timer-mins 45)

    (theme-buffet-timer-hours 2)
```


To load a theme from the current period:

``` emacs-lisp
    (theme-buffet-a-la-carte)
```


If instead you want to load a random theme from a prompted period:

``` emacs-lisp
    (theme-buffet-order-other-period)
```


To load an existing random theme without prompt:

``` emacs-lisp
    (theme-buffet-anything-goes)
```


To choose an existing timer to clear from a list of existing ones:

``` emacs-lisp
    (theme-buffet-clear-timers)
```


To clear all timers and start anew without leaving the mode:

``` emacs-lisp
    (theme-buffet-free-all-timers)
```



## Disclaimer

Disclaimer from Bruno Boal to the reader: This package was produced during
my learning sessions with Protesilaos "Prot" Stavrou and improved as
homework. Most of the credit goes to him, the mistakes you may find are my
own. Personally, despite the disadvantages and advantages of not being a
professional programmer, it is essential for me to always have fun and
enjoyment during learning and programming. In this respect, mission
accomplished, a big "thank you!" to my mentor. Also, keep in mind at least
two things - the fact that this package, like many others before it, has its
genesis in a collective effort, with didactic purposes and personal use in
mind, but also that future improvements could and should come from people
like you, a user of free software.


Happy hacking!
