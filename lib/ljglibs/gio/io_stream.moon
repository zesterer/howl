-- Copyright 2014-2017 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

ffi = require 'ffi'
require 'ljglibs.cdefs.gio'
core = require 'ljglibs.core'
import catch_error from require 'ljglibs.glib'

C = ffi.C

core.define 'GIOStream', {
  get_input_stream: => C.g_io_stream_get_input_stream @
  get_output_stream: => C.g_io_stream_get_output_stream @
  close: => catch_error C.g_io_stream_close, @, nil
}
