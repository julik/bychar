require 'helper'
require 'stringio'
require 'tempfile'



class BenchReader
  
  def initialize(reader_class)
    @reader = reader_class
    @io = File.open(File.dirname(__FILE__) + "/huge_nuke_tcl.tcl")
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

    Benchmark.benchmark("Different strategies for reading an IO byte by byte\n") do |x|
      x.report("Bare IO using read(1):       ") { reader0.run }
      x.report("Bychar using StringIO:       ") { reader1.run }
      x.report("Bychar using a String buffer:") { reader2.run }
    end
    
    assert true
  end
end

