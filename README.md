# Yeah, a mean dev-machine


It builds an *name of a Debian-based linux distribution* box and imports my [DotFiles](https://github.com/lukaszkorecki/DotFiles)


## How to?

- `gem install vagrant`
- `git submodule update --init`
- `vagrant up`


## What does it do? And how?

By using `chef-solo` and `vagrant` it builds a linux box, installs some awesome tools like

- weechat
- zsh
- vim

and makes `ruby-1.9.3` the default ruby.

Neat, eh?
