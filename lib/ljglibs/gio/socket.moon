-- Copyright 2014-2017 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

ffi = require 'ffi'
require 'ljglibs.cdefs.gio'
core = require 'ljglibs.core'
glib = require 'ljglibs.glib'
import gc_ptr from require 'ljglibs.gobject'
import catch_error, get_error from glib

C = ffi.C

GSocketAddress = core.define 'GSocketAddress', {
  new_inet: (address, port) -> C.g_inet_socket_address_new_from_string address, port
  new_unix: (address) -> C.g_unix_socket_address_new address
}, (def, address, port) -> def.new_inet address, port


GSocket = core.define 'GSocket', {
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

    'FAM_INVALID'
    'FAM_UNIX'
    'FAM_IPV4'
    'FAM_IPV6'
  }

  new: (family, type, protocol) ->
    gc_ptr catch_error C.g_socket_new, family, type, protocol

  new_from_fd: (fd) -> gc_ptr catch_error C.g_socket_new_from_fd, fd

  set_blocking: (value) => C.g_socket_set_blocking @, value

  bind: (address, allow_reuse=false) =>
    catch_error C.g_socket_bind, @, address, allow_reuse

  listen: => catch_error C.g_socket_listen, @

  accept: => gc_ptr catch_error C.g_socket_accept, @, nil

  connect: (address) =>
    status, ret, code = get_error C.g_socket_connect, @, address, nil
    if not status
      if code == C.G_IO_ERROR_PENDING
        -- Not an error: non-blocking connections raise G_IO_ERROR_PENDING
        nil
      else
        error "#{ret} (code: #{code})", 2

  send: (message) =>
    catch_error C.g_socket_send, @, message, #message, nil

  receive: (sz) =>
    buf = ffi.new 'gchar[?]', sz
    read = catch_error C.g_socket_receive, @, buf, sz, nil
    ffi.string buf, read

  get_fd: => C.g_socket_get_fd @
  condition_check: (cond) => C.g_socket_condition_check @, cond

  Address: GSocketAddress
}, (def, family, type, protocol) -> def.new family, type, protocol


for family in *{'INVALID', 'UNIX', 'IPV4', 'IPV6'}
  GSocket["FAMILY_#{family}"] = GSocket["FAM_#{family}"]

GSocket
