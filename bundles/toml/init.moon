mode_reg =
  name: 'toml'
  aliases: 'toml'
  extensions: { 'toml' }
  create: -> bundle_load('toml_mode')
  parent: 'curly_mode'

howl.mode.register mode_reg

unload = -> howl.mode.unregister 'toml'

return {
  info:
    author: 'Joshua Barretto',
    description: 'TOML support',
    license: 'MIT',
  :unload
}
