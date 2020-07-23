-- Copyright 2016 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)


howl.util.lpeg_lexer ->
  c = capture
  -- shorthand for lexer.word
  ident = (alpha + '_')^1 * (alpha + digit + '_')^0


  -- Comments.
  line_comment = P'#' * scan_until eol
  block_comment = span '/*', '*/'
  comment = c 'comment', any {line_comment, block_comment}


  hex_digit = R'09' + R'af' + R'AF' + '_'


  -- Strings.
  dq_str = span  '"', '"', '\\'
  raw_str_start = P'r'^0 * Cg(P'#'^0, 'lvl') * '"'
  raw_str_end = '"' * match_back 'lvl'
  raw_str = raw_str_start * scan_to raw_str_end
  -- Character.
  cont = R'\128\191'
  utf8 = R'\0\127' + R'\194\223' * cont + R'\224\239' * cont * cont + R'\240\244' * cont * cont * cont
  ascii_esc = '\\' * S'trn\'"\\0'
  unicode_esc = ('\\u{' * hex_digit^1 * '}')
  char = P"'" * (unicode_esc + ascii_esc + utf8) * P"'"
  string  = c 'string', any {dq_str, raw_str, char}


  -- Numbers.
  binary = P'0b' * S'01_'^1
  oct = P'0o' * S'01234567_'^1
  hex = P'0x' * hex_digit^1
  decimal = (digit + '_')^1
  floats = float * (S'eE' * S'+-'^-1 * decimal)^-1
  number = c 'number', any {
    binary,
    hex,
    oct,
    decimal,
    floats
  }


  -- Keywords.
  keyword = c 'keyword', word {
    'let', 'if',    'match', 'then', 'else',
	'given', 'in',    'as',   'with',
	'of',  'and',   'or',    'fn',
  }
  -- Special words
  special = c 'special', word { 'true', 'false' }


  -- Class/module declarations & type aliases
  decl = sequence {
    c 'keyword', word { 'def', 'type', 'data' }
    c 'whitespace', space^1
    c 'type_def', ident
  }
  -- Function declarations
  fdecl = sequence {
    c 'keyword', 'fn'
    c 'whitespace', space^1
    c 'fdecl', ident
  }


   -- Primitive Types.
  primitive = word {
    'Bool', 'Num', 'Char',
  }
  -- Library Types.
  library = upper^1 * (lower + digit)^1
  -- Lifetimes.
  lifetime = "'" * ident
  type = c 'type', any {lifetime, primitive}
  type_library = c 'constant', library

  -- Identifiers.
  identifier = c 'identifier', ident


  -- Operators.
  operator = c 'operator', S'+-/*%<>!=`^~@&|?#~:;,.()[]{}'


  -- Attributes.
  attribute = c 'preproc', (span (P'#![' + P'#['), P']')


  -- Syntax extensions.
  extension = c 'special', any {ident * S'!'}


  P {
    'all'

    all: any {
      decl,
      fdecl,
      special,
      keyword,
      extension,
      comment,
      string,
      type_library,
      type,
      attribute,
      number,
      operator,
      identifier,
    }
  }

