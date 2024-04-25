-- Copyright 2016 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)


howl.util.lpeg_lexer ->
  c = capture
  -- shorthand for lexer.word
  ident = (alpha + '_')^1 * (alpha + digit + '_')^0


  -- Comments.
  item_doc_comment = P'///' * scan_until eol
  global_doc_comment = P'//!' * scan_until eol
  doc_comment = c 'doc_comment', any {item_doc_comment, global_doc_comment}

  todo_comment = c 'todo', (P'//' * space^0 * P'TODO' * scan_until eol)

  line_comment = P'//' * scan_until eol
  inner = any { V'block_comment', complement('*/') }
  block_comment = '/*' * inner^0 * '*/'
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
    'abstract',   'alignof',    'as',       'become',   'box',
    'break',      'const',      'continue', 'crate',    'do',
    'else',       'enum',       'extern',   'final',    'fn',
    'for',        'if',         'impl',     'in',       'let',
    'loop',       'macro',      'match',    'mod',      'move',
    'mut',        'offsetof',   'override', 'priv',     'proc',
    'pub',        'pure',       'ref',      'return',   'sizeof',
    'static',     'struct',     'trait',    'typeof',   'type',
    'unsafe',     'unsized',    'use',      'virtual',  'where',
    'while',      'yield',      'async',    'await',    'dyn',
    'try'
  }
  -- Special words
  special = c 'special', word { 'true', 'false', 'self', 'super', 'Self' }


  -- Class/module declarations & type aliases
  struct_def = sequence {
    c 'keyword', word { 'mod', 'struct', 'enum', 'trait', 'type' }
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
    'bool', 'isize', 'usize', 'char', 'str',
    'u8', 'u16', 'u32', 'u64', 'u128'
    'i8', 'i16', 'i32', 'i64', 'i128',
    'f32','f64', 'f128'
  }
  -- Library Types.
  library = upper^1 * (lower + digit)^0
  -- Lifetimes.
  lifetime = "'" * ident
  type = c 'type', any {lifetime, primitive}
  type_library = c 'constant', library

  -- Identifiers.
  identifier = c 'identifier', ident


  -- Operators.
  operator = c 'operator', S'+-/*%<>!=`^~@&|?#~:;,.()[]{}'


  -- Attributes.
  attr_inner = any { V'attr_block', complement(']') }
  attr_block = '[' * attr_inner^0 * ']'
  attribute = c 'preproc', ('#' * attr_block)
  attribute_outer = c 'preproc', ('#!' * attr_block)


  -- Syntax extensions.
  extension = c 'special', any {ident * S'!'}


  P {
    'all'

    all: any {
      struct_def,
      fdecl,
      special,
      keyword,
      extension,
      todo_comment,
      doc_comment,
      comment,
      string,
      type_library,
      type,
      attribute,
      attribute_outer,
      number,
      operator,
      identifier,
    }
    block_comment: block_comment
    attr_block: attr_block
  }

