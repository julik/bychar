module Bychar
  class ReaderIOBuf
    # Default buffer size is 512k
    DEFAULT_BUFFER_SIZE = 512 * 1024
    
    def initialize(with_io, buffer_size = DEFAULT_BUFFER_SIZE)
      @io = with_io
      @bufsize = buffer_size
      cache
    end
    
    # Since you parse char by char, you will be tempted to do it in a tight loop
    # and to call eof? on each iteration. Don't. Instead. allow it to raise and do not check.
    # This takes the profile time down from 36 seconds to 30 seconds for a large file.
    def read_one_byte!
      cache if @buf.eos?
      raise EOF if @buf.eos?
      
      @buf.getch
    end
    
    private
    
    def cache
      data = @io.read(@bufsize)
      @buf = StringScanner.new(data.to_s) # Make nil become ""
    end
  end
end