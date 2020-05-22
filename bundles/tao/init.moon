-- Copyright 2016 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

mode_reg =
  name: 'tao'
  aliases: 'tao'
  extensions: 'tao'
  create: -> bundle_load('tao_mode')
  parent: 'curly_mode'

howl.mode.register mode_reg

unload = -> howl.mode.unregister 'tao'

return {
  info:
    author: 'Joshua Barretto <joshua.s.barretto@gmail.com>',
    description: 'Tao language support',
    license: 'MIT',
  :unload
}
