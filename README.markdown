# My Emacs config
## Initially forked from [emacs starter kit](http://github.com/technomancy/emacs-starter-kit/)

### Features, different from vanilla starter-kit

* scala-mode. To change all arrows to their unicode counterparts,
  `C-c p`
* latest ensime for scala development
* scamacs -- ecb for ensime for type inspection and other IDE-like stuff
* evil-mode: vim in your emacs. disable with `C-z`
* In emacs-state and insert-state some unicode conversions are
  available: map → ∘, >>= → ∗, all → ∀, any → ∃, etc.
* jabber.el and erc
* js2-mode
* rainbow-delemiters to distinguish between parentheses
* nyan-mode
* haskell-mode
* nav
* minimap (sublime-like)

*Note:* all the above stuff will get installed on your first run with
this config. You can then `M-x customize-themes`, and `M-x jabber-customize`.

### Random highlights on stuff, I use

* Ensime
  * `C-c C-v v` -- search for types in classpath
  * `C-c C-v z` -- scala repl with project classes on classpath
  * `C-c C-r t` -- find import for nonexisting symbol
  * `C-c C-v c` and `C-c C-v a` -- typecheck current file or the whole project
  * `TAB` -- autocomplete
  * `F12` -- ecb 
* Haskell-mode
  * `C-c C-z` -- haskell repl
  * `C-c C-l` -- load current file in it
* Jabber
  * `C-x C-j C-c` -- connect to ∀ servers
  * `C-x C-j C-d` -- disconnect
* IBuffer
  * `TAB` -- to jump between categories
  * `d` -- to mark buffers for delition, `x` to kill them. Much like
  package manager delition is working.
* Misc
  * `M-space` -- leave ony one space (remove multiple spaces ubnder cursor)
  * `C-x \` -- align selected by regexp
  * `C-x →` and `C-x ←` -- next/previous buffer
  * `C-x n n` -- narrow selected
  * `C-x n w` -- go back from narrowing
  * `F11` -- file navigation
  * `F10` -- minimap
  * `C-x +` will balance all buffers to occupy the same witdh/height

### Learning

This won't teach you Emacs, but it'll make it easier to get
comfortable. To access the tutorial, press C-h t.

You may also find the [PeepCode Meet Emacs
screencast](http://peepcode.com/products/meet-emacs) helpful. The
[Emacs Wiki](http://emacswiki.org) is also very handy.

## Installation

1. Install GNU Emacs 24
2. Clone this repo. Don't forget to `$ git submodule update`, as it
   uses some modes, available via github.
2. Rename this directory to ~/.emacs.d
   (If you already have a directory at ~/.emacs.d move it out of the
   way and put this there instead.)
3. Launch Emacs!

If you find yourself missing some autoloads after an update (which
should manifest itself as "void function: foobar" errors) try M-x
regen-autoloads. After some updates an M-x recompile-init will be
necessary; this should be noted in the commit messages.

If you want to keep your regular ~/.emacs.d in place and just launch a
single instance using the starter kit, try the following invocation:

  $ emacs -q -l ~/src/emacs-starter-kit/init.el

Note that having a ~/.emacs file might override the starter kit
loading, so if you've having trouble loading it, make sure that file
is not present.

## Structure

The init.el and overconfig.el files is where everything
begins. init.el is the first file to get loaded. overconfig.el, on the
other hand, is a file, intended for a user to customize.
The starter-kit-* files provide what is considered to be
better defaults, both for different programming languages and for
built-in Emacs features like bindings or registers.

Files that are pending submission to ELPA are bundled with the starter
kit under the directory elpa-to-submit/. The understanding is that
these are bundled just because nobody's gotten around to turning them
into packages, and the bundling of them is temporary. For these
libraries, autoloads will be generated and kept in the loaddefs.el
file. This allows them to be loaded on demand rather than at startup.

There are also a few files that are meant for code that doesn't belong
in the Starter Kit. First, the user-specific-config file is the file
named after your user with the extension ".el". In addition, if a
directory named after your user exists, it will be added to the
load-path, and any elisp files in it will be loaded. Finally, the
Starter Kit will look for a file named after the current hostname
ending in ".el" which will allow host-specific configuration. This is
where you should put code that you don't think would be useful to
everyone. That will allow you to merge with newer versions of the
starter-kit without conflicts.

## Emacs Lisp Package Archive

Libraries from [ELPA](http://tromey.com/elpa) are preferred when
available since dependencies are handled automatically, and the burden
to update them is removed from the user. In the long term, ideally
everything would be installed via ELPA, and only package.el would need
to be distributed with the starter kit. (Or better yet, package.el
would come with Emacs...) See starter-kit-elpa.el for a list of
libraries that are pending submission to ELPA. Packages get installed
in the elpa/ directory.

There's no vendor/ directory in the starter kit because if an external
library is useful enough to be bundled with the starter kit, it should
be useful enough to submit to ELPA so that everyone can use it, not
just users of the starter kit.

Sometimes packages are removed from the Starter Kit as they get added
to ELPA itself. This has occasionally caused problems with certain
packages. If you run into problems with such a package, try removing
everything from inside the elpa/ directory and invoking M-x
starter-kit-elpa-install in a fresh instance.

## Variants of Emacs

The Starter Kit is designed to work with GNU Emacs version 24 or
greater. Using it with forks or other variants is not supported. It
probably won't work with XEmacs, though some have reported getting it
to work with Aquamacs. However, since Aquamacs is not portable,
it's difficult to test in it, and breakage is common.

## Contributing

If you know your way around Emacs, please try out the starter kit as a
replacement for your regular dotfiles for a while. If there's anything
you just can't live without, add it or let me know so I can add
it. Take a look at what happens in init.el to get started.

Also: see the file TODO. Helping submit new libraries to ELPA is the
easiest way to help out. There are two ways you can do this: either
take new libraries and make them ready for ELPA, dropping them in the
elpa-to-submit directory or take files that are already in
elpa-to-submit, ensuring all their dependencies are correctly loaded
into ELPA, and sending them to the ELPA maintainer. There are details
at http://tromey.com/elpa/upload.html for how ELPA submission
works. Grep the project for TODO for other things.

Files are licensed under the same license as Emacs unless otherwise
specified. See the file COPYING for details.

On Unix, /home/$USER/.emacs.d, on windows Documents and Settings/%your
user name%/Application Data


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/folone/.emacs.d/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

