ffi = require 'ffi'
bit = require 'bit'
GSocketClient = require 'ljglibs.gio.socket_client'
import BufferedInputStream, OutputStream from howl.io
import PropertyObject from howl.util.moon
import dispatch from howl

C, ffi_cast = ffi.C, ffi.cast
append = table.insert


class Socket extends PropertyObject
  new: (address) =>
    super!
    @sock = GSocketClient!

    connected = dispatch.park 'socket-ready'
    local conn
    callback = (status, ret, err_code) ->
      conn = ret
      dispatch.resume connected

    @sock\connect_async address, callback
    dispatch.wait connected

    @_reader = BufferedInputStream conn\get_input_stream!
    @_writer = OutputStream conn\get_output_stream!

  inet_address: (address, port) -> GSocketClient.Address.new_inet address, port
  unix_address: (address) -> GSocketClient.Address.new_unix address

  @property reader: get: => @_reader
  @property writer: get: => @_writer
