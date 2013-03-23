require 'helper'
require 'stringio'

class TestReader < Test::Unit::TestCase
  def test_reads_once
    s = StringIO.new("This is a string")
    
    reader = Bychar.wrap(s)
    assert_equal "T", reader.read_one_char!
    assert_equal "h", reader.read_one_char!
  end
  
  def test_eof_with_empty
    s = StringIO.new
    reader = Bychar.wrap(s)
    assert_raise(Bychar::EOF) { reader.read_one_char! }
  end
  
  def test_eof_with_io_at_eof
    s = StringIO.new("foo")
    s.read(3)
    reader = Bychar.wrap(s)
    assert_raise(Bychar::EOF) { reader.read_one_char! }
  end
  
  def test_eof_with_string_to_size
    s = "Foobarboo another"
    s = StringIO.new(s)
    reader = Bychar.wrap(s)
    s.length.times { reader.read_one_char! }
    assert_raise(Bychar::EOF) { reader.read_one_char! }
  end
  
  def test_read_one_byte_and_raise_at_eof
    str = "Frobobo"
    bytes = []
    assert_raise(Bychar::EOF) do
      s = Bychar.wrap(StringIO.new(str))
      loop { bytes << s.read_one_char! }
    end
    
    assert_equal %w( F r o b o b o ), bytes
  end
  
end
