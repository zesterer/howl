ffi = require 'ffi'
bit = require 'bit'
callbacks = require 'ljglibs.callbacks'
GSocket = require 'ljglibs.gio.socket'
GIOCondition = require 'ljglibs.gio.condition'
import BufferedInputStream, InputStream, OutputStream from howl.io
import PropertyObject from howl.util.moon
import dispatch from howl

C, ffi_cast = ffi.C, ffi.cast
append = table.insert


class Socket
  inet_address: (address, port) -> GSocket.Address.new_inet address, port
  unix_address: (address) -> GSocket.Address.new_unix address


class TCPConnection extends PropertyObject
  new: (address) =>
    @sock = GSocket GSocket.FAMILY_IPV4, GSocket.TYPE_STREAM, GSocket.PROTOCOL_TCP
    @sock\set_blocking false
    @sock\connect address

    ready = dispatch.park 'tcp-connection-ready'
    poll = ->
      check = bit.bor GIOCondition.IN, GIOCondition.OUT
      if @sock\condition_check(check) != 0
        dispatch.resume ready
        false
      else
        true

    cb = callbacks.register poll, 'tcp-connection-check'
    C.g_idle_add_full C.G_PRIORITY_DEFAULT, callbacks.source_func, callbacks.cast_arg(cb.id), nil
    dispatch.wait ready

    @fd = @sock\get_fd!
    @reader = BufferedInputStream @fd
    @writer = OutputStream @fd


Socket.TCPConnection = TCPConnection
Socket
