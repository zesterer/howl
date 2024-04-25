mode_reg =
  name: 'glsl'
  aliases: { 'glsl' }
  extensions: { 'glsl', 'vert', 'frag', 'omwfx' }
  create: -> bundle_load('glsl_mode')
  parent: 'curly_mode'

howl.mode.register mode_reg

unload = -> howl.mode.unregister 'glsl'

return {
  info:
    author: 'Joshua Barretto',
    description: 'GLSL language support',
    license: 'MIT',
  :unload
}
