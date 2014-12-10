module Bychar
  class ReaderIOBuf
    
    def initialize(with_io, buffer_size = DEFAULT_BUFFER_SIZE)
      @io = with_io
      @bufsize = buffer_size
      cache
    end
    
    # Since you parse char by char, you will be tempted to do it in a tight loop
    # and to call eof? on each iteration. Don't. Instead. allow it to raise and do not check.
    # This takes the profile time down from 36 seconds to 30 seconds for a large file.
    def read_one_char
      cache if @buf.eos?
      return nil if @buf.eos?
      
      @buf.getch
    end
    
    private
    
    def cache
      data = @io.read(@bufsize)
      @buf = StringScanner.new(data.to_s) # Make nil become ""
    end
  end
end