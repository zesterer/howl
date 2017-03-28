-- Copyright 2014-2015 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

import InputStream from howl.io


class BufferedInputStream extends InputStream
  new: (stream, priority) =>
    super stream, priority
    @buffer = ''

  _pop_from_buffer: (num) =>
    result = @buffer\sub 1, num
    @buffer = @buffer\sub num+1
    result

  readline: (bufsz=128) =>
    while true
      nl = @buffer\find '\n'
      if nl
        return @_pop_from_buffer(nl)\gsub '\r\n', ''
      else
        @buffer ..= @read bufsz

  read_async: (num = 4096, handler) =>
    if num <= @buffer\len!
      result = @_pop_from_buffer num
      handler result
      nil

    elseif num > @buffer\len!
      result = @buffer
      @buffer = ''
      to_go = num - result\len!
      super to_go, (status, ret, err) ->
        if status
          handler status, (result .. ret), err
        else
          handler status, ret, err
