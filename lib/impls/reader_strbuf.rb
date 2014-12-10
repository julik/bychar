module Bychar
  # A String-bassed intermediary buffer.
  # We will only use it on 1.9 but we keep it compatible
  # with 1.8 so that we can benchmark both
  class ReaderStrbuf #:nodoc: :all
    def initialize(with_io)
      @io = with_io
      @pos_in_buf = 1
      @maximum_pos = 0
      @buf = ''
      @oneeight = RUBY_VERSION < "1.9"
    end

    # Will transparently read one byte off the contained IO, maintaining the internal cache.
    # If the cache has been depleted it will read a big chunk from the IO and cache it and then
    # return the byte
    def read_one_char
      if @pos_in_buf > @maximum_pos
        @buf = @io.read(DEFAULT_BUFFER_SIZE)
        
        return nil if @buf.nil?
      
        @maximum_pos = @buf.length - 1
        @pos_in_buf = 0
      end
    
      char_i = @pos_in_buf
      @pos_in_buf += 1
      
      # For Ruby 1.8 calling Numeric#chr is faster than allocating a Range for String#slice
      @oneeight ? @buf[char_i].chr : @buf[char_i]
    end
  end
end