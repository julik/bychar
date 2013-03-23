module Bychar
  
  # Bare reader that just proxies to an IO
  class ReaderBare #:nodoc: :all
    def initialize(io)
      @io = io
    end
  
    def read_one_char!
      b = @io.read(1)
      raise Bychar::EOF if b.nil?
      b
    end
  end
end