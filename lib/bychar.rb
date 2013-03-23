# -*- encoding : utf-8 -*-
require 'strscan'

require File.dirname(__FILE__) + "/impls/reader_iobuf"
require File.dirname(__FILE__) + "/impls/reader_strbuf"

module Bychar
  VERSION = '2.0.0'
  
  # Gets raised when you have exhausted the underlying IO
  class EOF < RuntimeError  #:nodoc: all
  end
  
  
  class Reader < ReaderStrbuf
  end
end