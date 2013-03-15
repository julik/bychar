require 'helper'

class TestBychar < Test::Unit::TestCase
  def test_reads_once
    s = StringIO.new("This is a string")
    
    reader = Bychar::Reader.new(s)
    assert_equal "T", reader.read_one_byte
    assert_equal "h", reader.read_one_byte
    assert !reader.eof?
  end
  
  def test_reads_set_buffer_size
    s = StringIO.new("abcd")
    flexmock(s).should_receive(:read).with(4).once.and_return("abcd")
    reader = Bychar::Reader.new(s, 4)
    reader.read_one_byte
  end
  
  def test_reads_in_64kb_chunks_by_default
    s = StringIO.new("abcd")
    flexmock(s).should_receive(:read).with(Bychar::DEFAULT_BUFFER_SIZE).once.and_return("abcd")
    reader = Bychar::Reader.new(s)
    reader.read_one_byte
  end
  
  def test_eof_with_empty
    s = StringIO.new
    reader = Bychar::Reader.new(s)
    assert s.eof?
  end
  
  def test_eof_with_io_at_eof
    s = StringIO.new("foo")
    s.read(3)
    reader = Bychar::Reader.new(s)
    assert reader.eof?
  end
  
  def test_eof_with_string_to_size
    s = "Foobarboo another"
    s = StringIO.new(s)
    reader = Bychar::Reader.new(s, 1)
    s.length.times { reader.read_one_byte }
    assert reader.eof?
  end
  
end
