-- Copyright 2016 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

howl.util.lpeg_lexer ->
  c = capture
  ident = (alpha + '_')^1 * (alpha + digit + '_')^0
  ws = c 'whitespace', space

  identifier = c 'identifier', ident

  operator = c 'operator', S'+-*/%&|^<>=!:;.,()[]{}'

  section = c 'class', line_start * span('[', ']')

  comment = c 'comment', P'#' * scan_until eol

  number = c 'number', any {
    float,
    hexadecimal_float,
    hexadecimal,
    octal,
    R'19' * digit^0,
  }

  string = c 'string', span('"', '"', '\\')

  constant = c 'special', word { 'true', 'false' }

  P {
    'all'

    all: any {
      comment,
      string,
      section,
      operator,
      number,
      constant,
      identifier,
    }
  }
