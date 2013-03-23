require 'helper'
require 'stringio'
require 'tempfile'



class BenchReader
  
  def initialize(reader_class)
    @reader = reader_class
  end
  
  def get_reader(io)
    @reader.new(io)
  end
  
  def pick
    get_reader(StringIO.new).class.to_s
  end
  
  def run
    File.open(File.dirname(__FILE__) + "/huge_nuke_tcl.tcl") do | io |
      reader = get_reader(io)
      begin
        loop { reader.read_one_char! * 2 }
      rescue Bychar::EOF
      end
    end
  end
end

class Auto
  def self.new(io)
    Bychar.wrap(io)
  end
end

class TestBenchmarkReaders < Test::Unit::TestCase
  def test_perf
    
    reader0 = BenchReader.new(Bychar::ReaderBare)
    reader1 = BenchReader.new(Bychar::ReaderIOBuf)
    reader2 = BenchReader.new(Bychar::ReaderStrbuf)
    reader3 = BenchReader.new(Auto)
    
    platform = "Platform-picked Bychar.wrap(io) #{reader3.pick}:"
    
    require 'benchmark'

    Benchmark.bm(5) do |x|
      x.report("Bare IO using read(1):".ljust(platform.length)) { reader0.run }
      x.report("Bychar using StringIO:".ljust(platform.length)) { reader1.run }
      x.report("Bychar using a String buffer:".ljust(platform.length)) { reader2.run }
      x.report(platform) { reader3.run }

    end
    
    assert true
  end
end

