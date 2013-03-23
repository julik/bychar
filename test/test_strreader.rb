require 'helper'
require 'stringio'

class TestStrReader < Test::Unit::TestCase
  def test_reads_once
    s = StringIO.new("This is a string")
    
    reader = Bychar::ReaderIOBuf.new(s)
    assert_equal "T", reader.read_one_byte!
    assert_equal "h", reader.read_one_byte!
  end
  
  def test_eof_with_empty
    s = StringIO.new
    reader = Bychar::ReaderStrbuf.new(s)
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_eof_with_io_at_eof
    s = StringIO.new("foo")
    s.read(3)
    reader = Bychar::ReaderStrbuf.new(s)
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_eof_with_string_to_size
    s = "Foobarboo another"
    s = StringIO.new(s)
    reader = Bychar::ReaderStrbuf.new(s)
    s.length.times { reader.read_one_byte! }
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_read_one_byte_and_raise_at_eof
    str = "Frobobo"
    
    bytes = []
    assert_raise(Bychar::EOF) do
      s = Bychar::ReaderStrbuf.new(StringIO.new(str))
      loop { bytes << s.read_one_byte! }
    end
    
    assert_equal %w( F r o b o b o ), bytes
  end
  
end
