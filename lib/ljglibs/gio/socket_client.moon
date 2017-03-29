-- Copyright 2014-2017 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

ffi = require 'ffi'
require 'ljglibs.cdefs.gio'
require 'ljglibs.gio.io_stream'
core = require 'ljglibs.core'
callbacks = require 'ljglibs.callbacks'
gio = require 'ljglibs.gio'
import gc_ptr from require 'ljglibs.gobject'
import catch_error, get_error from require 'ljglibs.glib'

C = ffi.C
ffi_cast = ffi.cast

core.define 'GSocketConnectable', {}


GSocketAddress = core.define 'GSocketAddress < GSocketConnectable', {
  new_inet: (address, port) -> C.g_inet_socket_address_new_from_string address, port
  new_unix: (address) -> C.g_unix_socket_address_new address
}, (def, address, port) -> def.new_inet address, port


GSocketConnection = core.define 'GSocketConnection < GIOStream', {}


core.define 'GSocketClient', {
  constants: {
    prefix: 'G_SOCKET_'

    'TYPE_INVALID'
    'TYPE_STREAM'
    'TYPE_DATAGRAM'
    'TYPE_SEQPACKET'

    'PROTOCOL_UNKNOWN'
    'PROTOCOL_DEFAULT'
    'PROTOCOL_TCP'
    'PROTOCOL_UDP'
    'PROTOCOL_SCTP'
  }

  new: -> gc_ptr C.g_socket_client_new!

  connect_async: (address, callback) =>
    local handle

    handler = (source, res) ->
      callbacks.unregister handle
      status, ret, err_code = get_error C.g_socket_client_connect_finish, @, res
      if not status
        callback false, ret, err_code
      else
        callback true, ret

    address = ffi_cast 'GSocketConnectable *', address
    handle = callbacks.register handler, 'socket-connect-async'
    C.g_socket_client_connect_async @, address, nil, gio.async_ready_callback, callbacks.cast_arg(handle.id)

  set_protocol: (protocol) => C.g_socket_client_set_protocol protocol
  set_type: (type) => C.g_socket_client_set_socket_type type

  Address: GSocketAddress
  Connection: GSocketConnection
}, (def) -> def.new!
