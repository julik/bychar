# -*- encoding : utf-8 -*-
require 'strscan'

require File.dirname(__FILE__) + "/impls/reader_iobuf"
require File.dirname(__FILE__) + "/impls/reader_strbuf"
require File.dirname(__FILE__) + "/impls/reader_bare"

module Bychar
  VERSION = '3.0.0'
  DEFAULT_BUFFER_SIZE = 512 * 1024
  
  # The basic wrapper that you get from wrap()
  class Wrapper
    def initialize(io_to_wrap)
      @io = io_to_wrap
    end
    
    def read_one_char
      @io.read_one_char
    end
    
    def each_char
      while char = read_one_char do
        yield char
      end
    end
  end
  
  # Returns a reader object that responds to read_one_char 
  # and can be passed on to the actual parsers
  def self.wrap(io)
    reader = if RUBY_PLATFORM == 'java'
      ReaderIOBuf.new(io)
    elsif RUBY_VERSION < '1.9'
      ReaderBare.new(io)
    else
      ReaderStrbuf.new(io)
    end
    Wrapper.new(reader)
  end
end