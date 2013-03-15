# -*- encoding : utf-8 -*-
require 'stringio'

module Bychar
  VERSION = '1.0.1'

  # Default buffer size is 512k
  DEFAULT_BUFFER_SIZE = 512 * 1024
  
  # This object helps you build parsers that parse an IO byte by byte without having to
  # read byte by byte.
  # Reading byte by byte is very inefficient, but we want to parse byte by byte since
  # this makes parser construction much easier. So what we do is cache some chunk of the
  # passed buffer and read from that. Once exhausted there will be some caching again,
  # and ad infinitum until the passed buffer is exhausted
  class Reader
    

    def initialize(with_io, buffer_size = DEFAULT_BUFFER_SIZE)
      @io = with_io
      @bufsize = buffer_size
      cache
    end

    # Will transparently read one byte off the contained IO, maintaining the internal cache.
    # If the cache has been depleted it will read a big chunk from the IO and cache it and then
    # return the byte
    def read_one_byte
      cache if @buf.nil? || @buf.eos?
      
      return nil if @buf.eos?
      return @buf.getch
    end
    
    # Tells whether all the data has been both read from the passed buffer
    # and from the internal cache buffer (checks whether there is anything that
    # can be retreived using read_one_byte)
    def eof?
      (@buf && @buf.eos?) && @io.eof?
    end

    private

    def cache
      data = @io.read(@bufsize)
      @buf = StringScanner.new(data.to_s) # Make nil become ""
    end
  end
end