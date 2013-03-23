require 'helper'
require 'stringio'

class TestBychar < Test::Unit::TestCase
  def test_reads_once
    s = StringIO.new("This is a string")
    
    reader = Bychar::ReaderIOBuf.new(s)
    assert_equal "T", reader.read_one_byte!
    assert_equal "h", reader.read_one_byte!
  end
  
  def test_reads_set_buffer_size
    s = StringIO.new("abcd")
    flexmock(s).should_receive(:read).with(4).once.and_return("abcd")
    reader = Bychar::ReaderIOBuf.new(s, 4)
    reader.read_one_byte!
  end
  
  def test_reads_in_64kb_chunks_by_default
    s = StringIO.new("abcd")
    flexmock(s).should_receive(:read).with(Bychar::DEFAULT_BUFFER_SIZE).once.and_return("abcd")
    reader = Bychar::ReaderIOBuf.new(s)
    reader.read_one_byte!
  end
  
  def test_eof_with_empty
    s = StringIO.new
    reader = Bychar::ReaderIOBuf.new(s)
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_eof_with_io_at_eof
    s = StringIO.new("foo")
    s.read(3)
    reader = Bychar::ReaderIOBuf.new(s)
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_eof_with_string_to_size
    s = "Foobarboo another"
    s = StringIO.new(s)
    reader = Bychar::ReaderIOBuf.new(s, 1)
    s.length.times { reader.read_one_byte! }
    assert_raise(Bychar::EOF) { reader.read_one_byte! }
  end
  
  def test_read_one_byte_and_raise_at_eof
    str = "Frobobo"
    
    bytes = []
    assert_raise(Bychar::EOF) do
      s = Bychar::ReaderIOBuf.new(StringIO.new(str))
      loop { bytes << s.read_one_byte! }
    end
    
    assert_equal %w( F r o b o b o ), bytes
  end
  
end
