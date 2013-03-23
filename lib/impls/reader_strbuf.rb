module Bychar
  class ReaderStrbuf #:nodoc: :all
    def initialize(with_io)
      @io = with_io
      @pos_in_buf = 1
      @maximum_pos = 0
      @buf = ''
    end

    # Will transparently read one byte off the contained IO, maintaining the internal cache.
    # If the cache has been depleted it will read a big chunk from the IO and cache it and then
    # return the byte
    def read_one_byte!
      if @pos_in_buf > @maximum_pos
        @buf = @io.gets #read(2048)
        raise EOF if @buf.nil?
      
        @maximum_pos = @buf.length - 1
        @pos_in_buf = 0
      end
    
      @pos_in_buf += 1
      @buf[@pos_in_buf - 1]
    end
  end
end