# -*- encoding : utf-8 -*-
require 'strscan'

require File.dirname(__FILE__) + "/impls/reader_iobuf"
require File.dirname(__FILE__) + "/impls/reader_strbuf"
require File.dirname(__FILE__) + "/impls/reader_bare"

module Bychar
  VERSION = '2.0.0'
  DEFAULT_BUFFER_SIZE = 512 * 1024
  
  # Gets raised when you have exhausted the underlying IO
  class EOF < EOFError  #:nodoc: all
  end
  
  # Returns a reader object that responds to read_one_char!
  # and raises an EOF if the IO is depleted
  def self.wrap(io)
    if RUBY_PLATFORM == 'java'
      ReaderIOBuf.new(io)
    elsif RUBY_VERSION < '1.9'
      ReaderBare.new(io)
    else
      ReaderStrbuf.new(io)
    end
  end
end