-- Copyright 2014-2015 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

ffi = require 'ffi'
require 'ljglibs.cdefs.cairo'
core = require 'ljglibs.core'

C, gc = ffi.C, ffi.gc

seen = {}

surface_gc_ptr = (o) ->
  -- gc(o, C.cairo_surface_destroy)
  gc o, (s) ->
    tos = tostring(s)
    cairo_reuse = seen[tos] and ' (REUSE FROM CAIRO)' or ''
    print "BEFORE auto destroy surface #{tos} with reference_count #{s.reference_count}#{cairo_reuse}"
    seen[tos] = true
    C.cairo_surface_destroy s
    print "AFTER auto destroy surface #{tos}: reference_count #{s.reference_count}"

core.define 'cairo_surface_t', {

  properties: {
    reference_count: {
      get: => tonumber(C.cairo_surface_get_reference_count @)
    }
  }

  create_similar: (other, content, width, height) ->
    s = surface_gc_ptr C.cairo_surface_create_similar other, content, width, height
    -- print "return similar #{tostring(s)} with reference_count = #{s.reference_count}"
    s

  write_to_png: (filename) =>
    C.cairo_surface_write_to_png @, filename

  destroy: =>
    gc(@, nil)
    tos = tostring(@)
    cairo_reuse = seen[tos] and ' (REUSE FROM CAIRO)' or ''
    print "BEFORE destroy surface #{tos} with reference_count #{@reference_count}#{cairo_reuse}"
    seen[tos] = true
    C.cairo_surface_destroy @
    print "AFTER destroy surface #{tos}: reference_count #{@reference_count}"

}
