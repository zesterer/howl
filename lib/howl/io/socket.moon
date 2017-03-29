ffi = require 'ffi'
GSocketClient = require 'ljglibs.gio.socket_client'
import BufferedInputStream, OutputStream from howl.io
import PropertyObject from howl.util.moon
import dispatch from howl


class Socket extends PropertyObject
  inet_address: (address, port) -> GSocketClient.Address.new_inet address, port
  unix_address: (address) -> GSocketClient.Address.new_unix address

  new: (address, options) =>
    super!
    @client = GSocketClient!

    if options
      @client\set_protocol @_convert_enum_to_int 'PROTOCOL', options.protocol if options.protocol
      @client\set_socket_type @_convert_enum_to_int 'TYPE', options.socket_type if options.socket_type
      @client\set_timeout options.timeout if options.timeout

    connected = dispatch.park 'socket-ready'
    callback = (status, ret, err_code) ->
      if status
        dispatch.resume connected, ret
      else
        dispatch.resume_with_error connected, "#{ret} (#{err_code})"

    @client\connect_async address, callback
    @conn = dispatch.wait connected

    @_reader = BufferedInputStream @conn\get_input_stream!
    @_writer = OutputStream @conn\get_output_stream!

  @property reader: get: => @_reader
  @property writer: get: => @_writer

  @property timeout:
    get: => @client\get_timeout!
    set: (value) => @client\set_timeout value

  @property socket_type:
    get: => @_convert_int_to_enum 'TYPE', @client\get_socket_type!

  @property protocol:
    get: => @_convert_int_to_enum 'PROTOCOL', @client\get_protocol!

  close: =>
    @conn\close!
    @reader\close!
    @writer\close!

  _convert_enum_to_int: (kind, value) =>
    value = GSocketClient["#{kind}_#{value\upper!}"]
    error "Invalid #{kind\lower!} '#{value}' given to Socket" if not value
    value

  _convert_int_to_enum: (kind, ival) =>
    for const in *GSocketClient.constants
      if const\match"^#{kind}" and ival == GSocketClient[const]
        return const\gsub("^#{kind}_", "")\lower!

    error "Invalid value in _convert_int_to_enum(kind=#{kind}, ivall=#{ival})"
