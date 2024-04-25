-- Copyright 2014-2015 The Howl Developers
-- License: MIT (see README.md at the top-level directory of the bundle)

{
  lexer: bundle_load('toml_lexer')
  comment_syntax: '#'
  default_config:
    use_tabs: false
    indent: 4

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
  }
}
