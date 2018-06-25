{:app, :Buffer, :command} = howl
{:Window} = howl.ui
Gtk = require 'ljglibs.gtk'

require 'howl.commands.edit_commands'

describe 'edit_commands', ->
  local old_win, old_ed
  setup ->
    -- old_win = app.window
    old_ed = app.editor

    -- app.window = Window win: Gtk.OffscreenWindow!
    app.editor = app\new_editor!

  teardown ->
    -- app.window = old_win
    app.editor = old_ed
    app._editors = {}

  local buffer, cursor

  before_each ->
    buffer = Buffer howl.mode.by_name 'default'
    buffer.config.indent = 2
    buffer.text = 'abc\ndef\nghi'
    app.editor.buffer = buffer
    cursor = app.editor.cursor

  after_each ->
    app\close_buffer buffer, true

  describe 'editor-move-lines-up', ->
    it 'moves the current line up', ->
      command, cursor, old_win, Window, Gtk
  --     cursor\move_to line: 2, column: 2
  --     command.editor_move_lines_up!

  --     assert.equal 'def\nabc\nghi', buffer.text
  --     assert.equal 1, cursor.line
  --     assert.equal 2, cursor.column

  --   it 'works properly at EOF', ->
  --     cursor\eof!
  --     command.editor_move_lines_up!

  --     assert.equal 'abc\nghi\ndef\n', buffer.text
  --     assert.equal 2, cursor.line
  --     assert.equal 4, cursor.column

  -- describe 'editor-move-text-right', ->
  --   it 'moves the current text to the right', ->
  --     cursor\move_to line: 1, column: 1
  --     command.editor_move_text_right!

  --     assert.equal 'bac\ndef\nghi', buffer.text
  --     assert.equal 1, cursor.line
  --     assert.equal 2, cursor.column

  --   it 'works properly right next to EOF', ->
  --     cursor\eof!
  --     cursor\left!
  --     cursor\left!
  --     command.editor_move_text_right!

  --     assert.equal 'abc\ndef\ngih', buffer.text
  --     assert.equal 3, cursor.line
  --     assert.equal 3, cursor.column
