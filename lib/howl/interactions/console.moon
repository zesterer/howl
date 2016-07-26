-- Copyright 2016 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

import app, interact from howl
import markup from howl.ui

console_history = {}

class Console
  run: (@finish, opts = {}) =>
    error 'console evaluator function not provided' unless opts.evaluator
    error 'console name not provided' unless opts.name
    @opts = moon.copy opts
    @name = @opts.name
    @command_line = app.window.command_line
    @results_widget = howl.ui.TextWidget
      show_h_scrollbar: true
      show_v_scrollbar: true
    @results_widget.max_height_request = math.floor app.window.allocated_height * 0.5
    @command_line\add_widget 'results', @results_widget

    @results_widget\show!

    with @command_line
      .prompt = opts.prompt or ''
      .title = opts.title

    unless console_history[@name]
      console_history[@name] = {
        text: markup.howl '<comment>Type an expression and press [enter]</comment>'
        commands: {}
      }
    @history = console_history[@name]
    @results_widget\append @history.text
    @refresh!

  refresh: =>
    @results_widget.visible_rows = #@results_widget.buffer.lines
    @results_widget\show!

  save_history:  =>
    @history.text = @results_widget.buffer\chunk 1, #@results_widget.buffer

  append: (expr, result) =>
    table.insert @history.commands, expr
    if result[1] != '\n' and @results_widget.buffer[#@results_widget.buffer] != '\n'
      @results_widget\append '\n'
    @results_widget\append result

  submit: =>
    expr = @command_line.text
    result = @opts.evaluator expr
    @append expr, result
    @command_line.text = ''
    @refresh!

  keymap:
    enter: =>
      @history_pos = nil
      @submit!
    escape: =>
      @save_history!
      self.finish!
    up: =>
      if @history_pos
        return if @history_pos == 1
        @history_pos -= 1
      else
        @history_pos = #@history.commands
      @command_line.text = @history.commands[@history_pos]
    down: =>
      return unless @history_pos
      if @history_pos == #@history.commands
        @history_pos = nil
        @command_line.text = ''
        return
      else
        @history_pos += 1
        @command_line.text = @history.commands[@history_pos]

interact.register
  name: 'console'
  description: 'Evaluate text entered by user and print result'
  factory: Console
