ffi = require 'ffi'
callbacks = require 'ljglibs.callbacks'
import InputStream from howl.io
import dispatch from howl

C, ffi_cast = ffi.C, ffi.cast
append = table.insert


class
