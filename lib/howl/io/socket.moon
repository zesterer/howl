ffi = require 'ffi'
bit = require 'bit'
GSocketClient = require 'ljglibs.gio.socket_client'
import BufferedInputStream, OutputStream from howl.io
import PropertyObject from howl.util.moon
import dispatch from howl

C, ffi_cast = ffi.C, ffi.cast
append = table.insert


class Socket extends PropertyObject
  new: (address, options) =>
    super!
    @sock = GSocketClient!

    if options
      @sock\set_protocol options.protocol if options.protocol
      @sock\set_socket_type options.socket_type if options.socket_type

    connected = dispatch.park 'socket-ready'
    callback = (status, ret, err_code) ->
      dispatch.resume connected, ret

    @sock\connect_async address, callback
    conn = dispatch.wait connected

    @_reader = BufferedInputStream conn\get_input_stream!
    @_writer = OutputStream conn\get_output_stream!

  inet_address: (address, port) -> GSocketClient.Address.new_inet address, port
  unix_address: (address) -> GSocketClient.Address.new_unix address

  @property reader: get: => @_reader
  @property writer: get: => @_writer
