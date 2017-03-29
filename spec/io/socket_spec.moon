import Process, Socket from howl.io

describe 'Socket', ->
  local nc

  nc_spec = (func) ->
    (done) ->
      howl_async ->
        nc = Process cmd: {'nc', '-l', '4444'}, write_stdin: true
        nc.stdin\write '1234\r\n'
        nc.stdin\close!
        func nc

        nc\send_signal 'TERM'
        nc\wait!
        done!

  localhost = Socket.inet_address '127.0.0.1', 4444

  describe 'new(address, options)', ->
    it 'connects successfully to the remote host', nc_spec (nc) ->
      sock = Socket localhost
      -- assert.equal '1234', sock.reader\readline!
      sock\close!

    it 'sets the given options', nc_spec ->
      sock = Socket localhost, protocol: 'tcp', socket_type: 'stream', timeout: 2
      assert.equal 'tcp', sock.protocol
      assert.equal 'stream', sock.socket_type
      assert.equal 2, sock.timeout
      sock\close!

  describe 'timeout', ->
    it 'sets the timeout', nc_spec ->
      sock = Socket localhost
      sock.timeout = 1
      assert.equal 1, sock.timeout
      sock\close!
