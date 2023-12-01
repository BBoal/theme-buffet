;;; theme-buffet.el --- Time based theme switcher -*- lexical-binding: t -*-

;; Copyright (C) 2023  Free Software Foundation, Inc.

;; Author: Bruno Boal <egomet@bboal.com>,
;;         Protesilaos Stavrou <info@protesilaos.com>
;; Maintainer: Theme-Buffet Development <~bboal/general-issues@lists.sr.ht>
;; URL: https://git.sr.ht/~bboal/theme-buffet
;; Version: 0.1.0
;; Package-Requires: ((emacs "29.1"))

;; This file is part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Theme-Buffet lets the user specify different time periods of the day and for
;; each period, a list of preferred themes to be randomly loaded accordingly.
;; To install you just have to clone the repo from the url, add the path to the
;; 'load-path variable and then require the library.  Here's an example, for
;; those who still love the Emacs 28 or earlier way of doing things:
;;
;;    # In the terminal
;;    git clone https://git.sr.ht/~bboal/theme-buffet ~/.emacs.d/theme-buffet
;;
;;    ;; In Emacs, evaluate
;;    (add-to-list 'load-path "~/.emacs.d/theme-buffet")
;;    (require 'theme-buffet)
;;
;; The newest way, from Emacs 29 onward:
;;
;;    (package-vc-install "https://git.sr.ht/~bboal/theme-buffet")
;;
;; There are two templates preconfigured available for usage.  One enabled by
;; default, with the standard themes that come with vanilla Emacs; the other
;; more fancier, can be easily enabled by evaluating the following:
;;
;;	  (setq theme-buffet-menu 'modus-ef)
;;
;; The binding above will set the themes to be either Modus or Ef, authored by
;; Protesilaos Stavrou <https://git.sr.ht/~protesilaos>, distributed across six
;; periods of the day (night, twilight, morning, day, afternoon and evening).  The
;; library will not require the aforementioned package, you will have to install it
;; manual if you intent to use it.  Finally to start using Theme-Buffet, evaluate:
;;
;;    (theme-buffet-mode 1)
;;
;; Following the appanage way of Emacs, both the names and number of themes and
;; time periods can be freely changed while mantaining the same structure.  There
;; is also a time-offset that can be set by the user to match a specific
;; time-zone/personal preference.  E.g
;;
;;    (setq theme-buffet-time-offset 2)
;;
;; All this can be achieved by tweaking `theme-buffet-end-user'.  For
;; inspiration, take a look at `theme-buffet--modus-ef' which is used when
;; setting `theme-buffet-menu' to 'modus-ef like demonstrated above.
;;
;;
;; Usage:
;;
;; There are several interactive functions available to the user serving as
;; entry points to the package.
;;
;; To set the menu for the desired themes property list and have the themes
;; change when the periods do: `theme-buffet-built-in',
;; `theme-buffet-modus-ef' and `theme-buffet-end-user'.
;;
;; To set the timer for a certain time interval of hours or minutes:
;;`theme-buffet-timer-hours' or `theme-buffet-timer-mins'.
;;
;; To load a theme from the current period: `theme-buffet-a-la-carte'.  If
;; instead you want to load a random theme from a prompted period, there's
;; `theme-buffet-order-other-period'.  To load an existing random theme use
;; `theme-buffet-anything-goes'.
;;
;; Some examples in lisp:
;;
;;    (theme-buffet-modus-ef) ; to set the theme plist to Modus and Ef
;;    (theme-buffet-timer-mins 30) ; to change theme every 30m from now
;;    (theme-buffet-timer-hours 2) ; to also change every 2h from now
;;
;; Interactively, as an example, you would press M-x and execute
;; `theme-buffet-order-other-period'.  Then, after choosing any defined period,
;;you would get returned a random loaded theme from the aforementioned period.

;;
;; Disclaimer from Bruno Boal to the reader: This package was produced during my
;; learning sessions with Protesilaos "Prot" Stavrou and improved as
;; homework.  Most of the credit goes to him, the mistakes you may find are my
;; own.  Personally, despite the disadvantages and advantages of not being a
;; professional programmer, it is essential for me to always have fun and
;; enjoyment during learning and programming.  In this respect, mission
;; accomplished, a big "thank you!" to my mentor.  Also, keep in mind at least
;; two things - the fact that this package, like many others before it, has its
;; genesis in a collective effort, with didatic purposes and personal use in
;; mind, but also that future improvements could and should come from people
;; like you, a user of free software.
;;
;; Happy hacking!

;;; Code:


(defgroup theme-buffet nil
  "Time based theme switcher.
Assortment of preference based themes available for consumption according to
the time of the day.  A true theme feast for the eyes..."
  :group 'faces)

(defun theme-buffet--set-const-themes ()
  "Get list of themes from `custom-available-themes'.
Return a new list with the symbol const prepended to each element for usage in
`theme-buffet--end-user' type options."
    (mapcar (lambda (theme)
                (list 'const theme))
            (custom-available-themes)))

(defvar theme-buffet--const-themes (theme-buffet--set-const-themes))

(defconst theme-buffet--built-in
  '(:night     (wheatgrass manoj-dark modus-vivendi)
    :morning   (adwaita whiteboard leuven modus-operandi tango dichromacy tsdh-light)
    :afternoon (leuven-dark tango-dark tsdh-dark misterioso)
    :evening   (deeper-blue wombat))
  "Emacs default themes distributed along 4 defined periods.")

(defconst theme-buffet--modus-ef
  '(:night     (ef-autumn
                ef-duo-dark
                ef-night
                ef-tritanopia-dark
                ef-winter
                ef-dark
                modus-vivendi-deuteranopia)
    :twilight  (ef-bio
                ef-cherie
                modus-vivendi
                modus-vivendi-tritanopia)
    :morning   (ef-elea-light
                ef-maris-light
                ef-spring
                ef-tritanopia-light
                modus-operandi-tritanopia)
    :day       (ef-deuteranopia-light
                ef-frost
                ef-light
                ef-trio-light
                modus-operandi
                modus-operandi-deuteranopia)
    :afternoon (ef-cyprus
                ef-day
                ef-duo-light
                ef-kassio
                ef-melissa-light
                ef-summer
                modus-operandi-tinted)
    :evening   (ef-deuteranopia-dark
                ef-elea-dark
                ef-maris-dark
                ef-melissa-dark
                ef-symbiosis
                ef-trio-dark
                modus-vivendi-tinted))
  "Different periods of the day combined with Ef or Modus themes.
For those who just don't have the time and want the best.")

(defcustom theme-buffet--end-user
  '(:night     (wheatgrass manoj-dark modus-vivendi)
    :morning   (adwaita whiteboard leuven modus-operandi tango dichromacy tsdh-light)
    :afternoon (leuven-dark tango-dark tsdh-dark misterioso)
    :evening   (deeper-blue wombat))
  "Associate day periods with list of themes.
Each association is of the form `:KEYWORD (THEMES)' where :KEYWORD is one among
:dark, :twilight, :dawn, etc, and (THEMES), a list of existent themes.
Prefilled with Emacs default themes as an example to be changed by the user."
  :type `(plist
          :options
          (((const :tag "Darkness of the night" :night)
            (repeat (choice symbol ,@theme-buffet--const-themes)))
           ((const :tag "Bright sun is up" :morning)
            (repeat (choice symbol ,@theme-buffet--const-themes)))
           ((const :tag "Perhaps a clouded afternoon" :afternoon)
            (repeat (choice symbol ,@theme-buffet--const-themes)))
           ((const :tag "Close to the sunset" :evening)
            (repeat (choice symbol ,@theme-buffet--const-themes))))))

(defcustom theme-buffet-menu 'built-in
  "Define which property list to use when selecting the theme list."
  :type '(choice (const :tag "Built-in Emacs themes" built-in)
                 (const :tag "Modus and Ef themes" modus-ef)
                 (const :tag "User specified themes" end-user)))

(defun theme-buffet--selected-menu ()
  "Return property list based on `theme-buffet-menu' value."
  (pcase theme-buffet-menu
    ('built-in theme-buffet--built-in)
    ('modus-ef theme-buffet--modus-ef)
    ('end-user theme-buffet--end-user)))

(defun theme-buffet--hours-secs (hours)
  "Number of seconds in HOURS."
  (* hours 60 60))

(defconst theme-buffet--secs-in-day
  (theme-buffet--hours-secs 24)
  "Number of seconds in a day.")

(defun theme-buffet--keywords ()
  "Get the name of the keywords defining the day periods."
  (if-let ((selected-menu (theme-buffet--selected-menu))
           ((plistp selected-menu)))
        (seq-filter #'keywordp selected-menu)
      (user-error "The Theme-Buffet Chef cannot work with your supplied themes.  Check `theme-buffet-menu'")))

(defun theme-buffet--periods ()
  "Get the number of keywords that define the day periods."
  (length (theme-buffet--keywords)))

(defun theme-buffet--interval ()
  "Get the number of seconds that each given time period should remain active."
  (/ theme-buffet--secs-in-day (theme-buffet--periods)))

(defun theme-buffet--get-time ()
  "Get the `current-time' in seconds."
  (let ((time-smh (take 3 (decode-time)))
        seconds)
    (while time-smh
      (setq seconds (cons (pop time-smh) seconds)
            time-smh (mapcar (lambda (n) (* 60 n))
                             time-smh)))
    (apply #'+ seconds)))

(defun theme-buffet--natnum-from-to (start end &optional step)
  "Create a list for applying in defcustom's type choice customization.
When not provided, STEP will default to 1.
The final list is of the form ((const START) (const START+STEP) ... (const
END-STEP) (const END))"
  (mapcar (lambda (x)
            (list 'const x))
          (number-sequence start end step)))

(defcustom theme-buffet-time-offset 0
  "Added time in HOURS (integer number) to shift the day periods.
Used for compensate winter/summer times or specific weather situations."
  :type `(choice ,@(theme-buffet--natnum-from-to -12 12)))

(defun theme-buffet--get-offset ()
  "Error checking for `theme-buffet-time-offset' variable.
Has to be an integer number and no greater than 12h in absolute value"
  (cond
   ((or (not (integerp theme-buffet-time-offset))
        (> (abs theme-buffet-time-offset) 12))
    (message "Theme-Buffet offset should be an integer number between -12 to 12 instead of `%s'.  Resetting to 0."
             theme-buffet-time-offset)
    0)
   (t
    (theme-buffet--hours-secs theme-buffet-time-offset))))

(defun theme-buffet--current-period ()
  "Get the current period reference the number of keywords in `theme-buffet'."
  (let ((offset (mod (+ (theme-buffet--get-time)
                        (theme-buffet--get-offset))
                     theme-buffet--secs-in-day)))
    (ceiling offset (theme-buffet--interval))))

(defun theme-buffet--get-period-keyword ()
  "Get the keyword of the current period as specified in `theme-buffet'."
  (nth (1- (theme-buffet--current-period)) (theme-buffet--keywords)))

(defun theme-buffet--reload-theme (chosen-theme &optional added-message)
  "Load CHOSEN-THEME after disabling the current one.
An additional ADDED-MESSAGE can be appended to the original string for added
information."
  (let ((standard-message "Theme-Buffet served")
        (added-message (or added-message "")))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme chosen-theme :no-confirm)
    (message "%s `%s' %s" standard-message chosen-theme added-message)))

(defun theme-buffet--get-theme-list (period)
  "Get list of themes of PERIOD, excluding the current if more are available."
  (when-let ((selected-menu (theme-buffet--selected-menu))
             (theme-list (plist-get selected-menu period)))
    (or (remq (car custom-enabled-themes) theme-list)
        theme-list)))

(defun theme-buffet--load-random (&optional period)
  "Load random theme according to PERIOD.

Omit current theme if it's not the only pertaining to the list of the
corresponding period.  Being this the case, the same theme shall be served.

An error message will appear if the theme is not available to load through
`load-theme'."
  (let ((period (or period (theme-buffet--get-period-keyword))))
    (if-let ((themes (theme-buffet--get-theme-list period))
             (chosen-theme (seq-random-elt themes))
             ((memq chosen-theme (custom-available-themes))))
        (theme-buffet--reload-theme chosen-theme)
      (user-error "Theme-Buffet Chef says `%s' is not known or installed!"
                  chosen-theme))))

(defvar theme-buffet-theme-history nil
  "Theme-Buffet period history.")

(defun theme-buffet--theme-prompt ()
  "Prompt the user the theme to choose for the present period."
  (let ((prompt "From current period choose a theme: ")
        (collection (theme-buffet--get-theme-list
                     (theme-buffet--get-period-keyword)))
        (history-var 'theme-buffet-theme-history))
    (completing-read prompt collection nil t nil history-var)))

;;;###autoload
(defun theme-buffet-a-la-carte ()
  "Prompt user for a theme according to the current period of the day."
  (declare (interactive-only t))
  (interactive)
  (let ((chosen-theme (intern (theme-buffet--theme-prompt))))
    (theme-buffet--reload-theme chosen-theme "according to your wishes. Enjoy..." )))

(defvar theme-buffet-period-history nil
  "Theme-Buffet period history.")

(defun theme-buffet--period-prompt ()
  "Prompt user for the day period from the list of periods."
  (let ((prompt "Choose a period of the day: ")
        (collection (theme-buffet--keywords))
        (history-var 'theme-buffet-order-history))
    (completing-read prompt collection nil t nil history-var)))

;;;###autoload
(defun theme-buffet-order-other-period ()
  "Interactively load a random theme from a prompted period."
  (declare (interactive-only t))
  (interactive)
  (let ((period (intern (theme-buffet--period-prompt))))
    (theme-buffet--load-random period)))

;;;###autoload
(defun theme-buffet-anything-goes ()
  "Interactively load an existing random theme."
  (declare (interactive-only t))
  (interactive)
  (theme-buffet--reload-theme (seq-random-elt (custom-available-themes))
                              "as a suprise"))

(defvar theme-buffet-user-timers-history nil
  "Theme-Buffet user timers history.")

;;;; Period timer
(defvar theme-buffet-timer-periods nil
  "Timer that calls Theme-Buffet's Chef into the kitchen.")

;;;; Hourly timer
(defvar theme-buffet-timer-hours nil
  "Timer that calls one of Theme-Buffet's Sous-Chef into the kitchen.")

;;;; Minutely timer
(defvar theme-buffet-timer-mins nil
  "Timer that calls another Theme-Buffet's Sous-Chef into the kitchen.")

(defun theme-buffet--free-timer (timer-obj)
  "Cancel and set to nil the timer TIMER-OBJ."
  (when-let (((boundp timer-obj))
             (obj (symbol-value timer-obj)))
    (cancel-timer obj)
    (set timer-obj nil)
    (message "Break time in the Theme-Buffet kitchen!")))


(defmacro theme-buffet--define-timer (units)
  "Define interactive functions to set timer in UNITS.
UNITS is an unquoted symbol, mins or hours and refers to timer of the same
naming."
  (let ((fn-name (intern (format "theme-buffet-timer-%s" units)))
        factor max-num)
    (pcase units
      ('mins (setq factor 60 max-num 180))
      ('hours (setq factor 3600 max-num 12))
      (_ (user-error
          "Bad `units' arg on `theme-buffet--define-timer %s'" units)))
    `(defun ,fn-name (number)
       ,(format "Set interactively the timer for NUMBER of %s.
When NUMBER is 0, the timer is cancelled. Maximum value is %s" units max-num)
       (interactive
        (list (read-number ,(format "Theme Buffet service in how many %s? " units) nil
                           'theme-buffet-user-timers-history)))
       (if-let (((natnump number))
                ((<= number ,max-num))
                (timer-secs (* ,factor number)))
           (if (equal number 0)
               (theme-buffet--free-timer ',fn-name)
             (setq ,fn-name (run-at-time timer-secs timer-secs
                                         #'theme-buffet--load-random
                                         (theme-buffet--get-period-keyword)))
             (message "Theme-Buffet Sous-Chef is rushing into the kitchen..."))
         (user-error "The input number should be a natural up to %s instead of `%s'"
                     ,max-num number)))))

;;;###autoload (autoload 'theme-buffet-timer-mins "theme-buffet")
(theme-buffet--define-timer mins)   ; (theme-buffet-timer-mins n)
;;;###autoload (autoload 'theme-buffet-timer-hours "theme-buffet")
(theme-buffet--define-timer hours)  ; (theme-buffet-timer-hours n)


(defmacro theme-buffet--define-menu-defuns (menu)
  "Define interactive functions to choose property list with themes to use.
The timer is clean, the chosen MENU is set with it's corresponding keywords."
  (let* ((doc-built-in "Built-in Emacs themes. If you like minimalism and standard suits your needs.")
         (doc-modus-ef "The way to go when you're in a hurry and need to feast fast but in style.
Theme-Buffet uses both Modus and Ef themes, mixed and matched for a maximum
\"Wow!!\" factor of pleasure and professionalism. At least in this developer's
opinion.")
         (doc-end-user "End user selected themes")
         (docstring (pcase menu
                     ('built-in doc-built-in)
                     ('modus-ef doc-modus-ef)
                     ('end-user doc-end-user)
                     (_ "This is not correct!"))))
    `(defun ,(intern (format "theme-buffet-%s" menu)) ()
       ,docstring
       (interactive)
       (or theme-buffet-mode (theme-buffet-mode 1))
       (theme-buffet--free-timer 'theme-buffet-timer-periods)
       (setq theme-buffet-menu (quote ,menu)
             theme-buffet-timer-periods
             (run-at-time t (theme-buffet--interval)
                          #'theme-buffet--load-random))
       (message "Sucess! Theme-Buffet Chef is firing up %s themes..." ',menu))))

;;;###autoload (autoload 'theme-buffet-built-in "theme-buffet")
(theme-buffet--define-menu-defuns built-in)  ; (theme-buffet-built-in)
;;;###autoload (autoload 'theme-buffet-modus-ef "theme-buffet")
(theme-buffet--define-menu-defuns modus-ef)  ; (theme-buffet-modus-ef)
;;;###autoload (autoload 'theme-buffet-end-user "theme-buffet")
(theme-buffet--define-menu-defuns end-user)  ; (theme-buffet-end-user)


;;;###autoload
(define-minor-mode theme-buffet-mode
  "Theme-Buffet serves your preferred themes according to the time of day.
You eyes will thank you.  Or not...

The preference for the themes is specified in the `theme-buffet-menu'"
  :global t
  (if theme-buffet-mode
      (unless (plistp (theme-buffet--selected-menu))
           (user-error "`theme-buffet-menu' isn't passing the health inspections as it is!"))
    (cancel-function-timers #'theme-buffet--load-random)))


(provide 'theme-buffet)
;;; theme-buffet.el ends here
