-- import BufferedInputStream, File from howl.io
-- GFile = require 'ljglibs.gio.file'

describe 'BufferedInputStream', ->
  -- with_stream_for = (contents, cb) ->
  --   howl_async ->
  --     File.with_tmpfile (f) ->
  --       f.contents = contents
  --       cb BufferedInputStream GFile(f.path)\read!

  describe 'readline', ->
    it 'does stuff', ->
      assert.is_true true
