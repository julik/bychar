require 'helper'
require 'stringio'
require 'tempfile'



class BenchReader < Struct.new(:reader_class, :io)
  
  LINES = 40_000
  
  def initialize(reader_class)
    @reader = reader_class
    prepare_file
  end
  
  def prepare_file
    # Allocate a HUGE file
    @io = Tempfile.new("readerTest")
    LINES.times {|t|  @io.puts "#{t} -> Lorem ipsum dolor sit amet" }
    @io.rewind
  end
  
  def run
    @io.rewind
    reader = @reader.new(@io)
    begin
      loop { reader.read_one_byte! * 2 }
    rescue Bychar::EOF
    end
  end
end

class Bare
  def initialize(io)
    @io = io
  end
  
  def read_one_byte!
    b = @io.read(1)
    raise Bychar::EOF if b.nil?
    b
  end
end

class TestBenchmarkReaders < Test::Unit::TestCase
  def test_perf
    reader0 = BenchReader.new(Bare)
    reader1 = BenchReader.new(Bychar::ReaderIOBuf)
    reader2 = BenchReader.new(Bychar::ReaderStrbuf)

    require 'benchmark'

    Benchmark.bm(50) do |x|
      x.report("Bare IO using read(1) with a wrapper method:\n") { reader0.run }
      x.report("Reader using StringIO and method calls:\n") { reader1.run }
      x.report("Reader using a String buffer and gets:\n") { reader2.run }
    end
    
    assert true
  end
end

