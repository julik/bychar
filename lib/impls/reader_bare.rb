module Bychar
  
  # Bare reader that just proxies to an IO
  class ReaderBare #:nodoc: :all
    def initialize(io)
      @io = io
    end
  
    def read_one_char
      @io.read(1)
    end
  end
end