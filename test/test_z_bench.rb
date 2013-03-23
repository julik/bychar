require 'helper'
require 'stringio'
require 'tempfile'



class BenchReader
  
  def initialize(reader_class)
    @reader = reader_class
    @io = File.open(File.dirname(__FILE__) + "/huge_nuke_tcl.tcl")
  end
  
  def get_reader
    @reader.new(@io)
  end
  
  def run
    @io.rewind
    reader = get_reader
    begin
      loop { reader.read_one_byte! * 2 }
    rescue Bychar::EOF
    end
  end
end

class AutoReaderBench < BenchReader
  def initialize
    super(nil)
  end
  
  def get_reader
    Bychar.wrap(@io)
  end
end


class TestBenchmarkReaders < Test::Unit::TestCase
  def test_perf
    reader0 = BenchReader.new(Bychar::ReaderBare)
    reader1 = BenchReader.new(Bychar::ReaderIOBuf)
    reader2 = BenchReader.new(Bychar::ReaderStrbuf)
    reader3 = AutoReaderBench.new
    
    require 'benchmark'

    Benchmark.benchmark("Different strategies for reading an IO byte by byte\n") do |x|
      x.report("Bare IO using read(1):       ") { reader0.run }
      x.report("Bychar using StringIO:       ") { reader1.run }
      x.report("Bychar using a String buffer:") { reader2.run }
      x.report("Auto-picked Bychar.wrap(io): ") { reader3.run }

    end
    
    assert true
  end
end

