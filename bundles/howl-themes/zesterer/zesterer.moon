-- color source : https://github.com/sindresorhus/hyper-snazzy

{:delegate_to} = howl.util.table

colors = {
  bg: "#1f2a30"
  margin_bg: "#1f313a"
  todo_bg: "#3d1c1b"
  -- fg: "#F1F1F0"
  fg: "#d8d8d8"
  white: "#ffffff"
  green: "#5AF78E"
  turq: "#99EDFE"
  special: "#7eeadf"
  blue: "#57C7FF"
  red: "#FF5C56"
  redder: "#dd9996"
  pink: "#FF6AC1"
  pale_pink: "#dd96c0"
  brown: "#e8c87d"
  yellow: "#f4d924"
  cream: "#ccb696"
  grey: "#808b8e"
  gutter: "#879aa3"
  evergreen: "#84b795"
  search: '#a9f28e'
  member: "#9ec9d6"
}

content_box = {
  background:
    color: colors.margin_bg
  border:
    width: 1
    color: colors.margin_bg
  border_right:
    width: 4
    color: colors.margin_bg
  border_bottom:
    width: 4
    color: colors.margin_bg
  header:
    background:
      color: colors.margin_bg
    border_bottom:
      color: colors.margin_bg
    color: colors.fg
    font: bold: true
    padding: 1
  footer:
    background:
      color: colors.margin_bg
    border_top:
      color: colors.margin_bg
    color: colors.fg
    padding: 1
}

return {
  window:
    background:
      color: colors.margin_bg
    status:
      font:
        bold: true
        italic: true
      color: colors.fg
      info: color: colors.fg
      warning: color: colors.yellow
      'error': color: colors.red

  :content_box

  popup:
    background:
      color: colors.margin_bg
    border:
      color: colors.grey

  editor: delegate_to content_box, {
    background: color: colors.bg

    indicators:
      default:
        color: colors.fg
      title:
        font: bold: false
      vi:
        font: bold: true

    caret:
      color: colors.white
      width: 1

    current_line:
      background: colors.white -- ?

    gutter:
      color: colors.gutter
      background:
        color: colors.margin_bg
  }

  flairs:
    indentation_guide:
      type: flair.PIPE,
      foreground: colors.fg, -- ?
      foreground_alpha: 0.5,
      line_width: 0.5

    indentation_guide_1:
      type: flair.PIPE,
      foreground: colors.grey,
      foreground_alpha: 0.5,
      line_width: 0.5

    indentation_guide_2:
      type: flair.PIPE,
      foreground: colors.grey,
      foreground_alpha: 0.5,
      line_width: 0.5

    indentation_guide_3:
      type: flair.PIPE,
      foreground: colors.grey,
      foreground_alpha: 0.5,
      line_width: 0.5
    edge_line:
      type: flair.PIPE,
      foreground: colors.grey,
      foreground_alpha: 0.5,
      line_width: 0.5

    search: -- selected search
      type: highlight.ROUNDED_RECTANGLE
      --foreground_alpha: 1
      background: colors.search
      background_alpha: 0.35
      --text_color: colors.bg
      height: 'text'

    search_secondary: -- non selected search
      type: flair.ROUNDED_RECTANGLE
      background: colors.search
      background_alpha: 0.2
      --text_color: colors.bg
      height: 'text'

    replace_strikeout:
      type: flair.ROUNDED_RECTANGLE
      foreground: colors.fg -- ?
      background: colors.bg
      text_color: colors.fg
      height: 'text'

    brace_highlight:
      type: flair.ROUNDED_RECTANGLE
      background: colors.evergreen
      background_alpha: 0.25
      height: 'text'

    brace_highlight_secondary:
      type: flair.ROUNDED_RECTANGLE
      background: colors.pink
      background_alpha: 0.25
      height: 'text'

    list_selection:
      type: flair.RECTANGLE
      background: colors.brown -- CHECK!
      background_alpha: 0.3

    list_highlight:
      type: highlight.UNDERLINE
      foreground: colors.fg
      text_color: colors.fg
      line_width: 2

    cursor:
      type: flair.RECTANGLE
      background: colors.fg
      width: 2
      height: 'text'

    block_cursor:
      type: flair.ROUNDED_RECTANGLE,
      background: colors.fg
      text_color: colors.bg
      height: 'text',
      min_width: 'letter'

    selection:
      type: highlight.ROUNDED_RECTANGLE
      background: colors.turq
      background_alpha: 0.2
      min_width: 'letter'

  styles:
    default:
      color: colors.fg

    red: color: red
    green: color: green
    yellow: color: yellow
    blue: color: blue
    magenta: color: purple
    cyan: color: aqua

    popup: -- ?
      background: colors.brown
      color: colors.fg

    comment:
      font: italic: true
      color: colors.grey

    doc_comment:
        font: italic: true
        color: colors.cream

    variable:
      color: colors.fg

    label:
      color: colors.fg
      font: italic: true

    key:
      color: colors.fg
      font: bold: false

    fdecl:
      color: colors.blue
      font: bold: false

    keyword:
      color: colors.green
      font: bold: false

    class:
      color: colors.redder

    type_def:
      color: colors.redder
      font: bold: false

    definition:
      color: colors.fg

    function:
      color: colors.green
      font: italic: true

    type:
      color: colors.red
      font: italic: false

    char: color: colors.brown
    number: color: colors.pale_pink
    operator: color: colors.blue
    preproc: color: colors.evergreen
    special: color: colors.special
    tag: color: colors.member
    member: color: colors.member
    info: color: colors.fg
    constant: color: colors.redder
    string: color: colors.brown

    regex:
      color: colors.fg
      background: colors.bg

    embedded:
      color: colors.fg
      background: colors.bg

    todo:
      color: colors.fg
      background: colors.todo_bg

    -- Markup and visual styles

    error:
      font: italic: true
      color: colors.fg
      background: colors.bg

    warning:
      font: italic: true
      color: colors.fg

    h1:
      font: bold: true
      color: colors.turq

    h2:
      font: bold: true
      color: colors.turq

    h3:
      font: italic: true
      color: colors.turq

    emphasis:
      font:
        bold: true
        italic: true

    strong: font: italic: true
    link_label: color: colors.brown
    link_url: color: colors.brown

    table:
      color: colors.fg
      background: colors.bg
      underline: true

    addition: color: colors.green
    deletion: color: colors.red
    change: color: colors.turq
  }
