core = require 'ljglibs.core'
ffi = require 'ffi'

GIOCondition =
  IN: ffi.C.G_IO_COND_IN
  OUT: ffi.C.G_IO_COND_OUT
  ERR: ffi.C.G_IO_COND_ERR
  HUP: ffi.C.G_IO_COND_HUP
  NVAL: ffi.C.G_IO_COND_NVAL

GIOCondition
