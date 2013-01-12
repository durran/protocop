require "benchmark"

def benchmark!
  Benchmark.bm do |bench|

    bench.report("Protocop::Buffer#write_boolean -->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_boolean(true)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_double  -->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_double(n.to_f)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_int32 ---->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_int32(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_int64 ---->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_int64(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_fixed32 -->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_fixed32(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_fixed64 -->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_fixed64(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_float ---->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_float(n.to_f)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_sfixed32 ->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_sfixed32(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_sfixed64 ->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_sfixed64(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_sint32 --->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_sint32(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_sint64 --->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_sint64(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_uint32 --->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_uint32(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_uint64 --->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_uint64(n)
      end
    end

    GC.start

    bench.report("Protocop::Buffer#write_string --->") do
      1_000_000.times do |n|
        Protocop::Buffer.new.write_string("#{n}")
      end
    end

    GC.start

    bench.report("Protocop::Buffer#read_boolean --->") do
      500_000.times do |n|
        buffer = Protocop::Buffer.new
        buffer.write_boolean(true)
        buffer.read_boolean
      end
    end

    GC.start

    bench.report("Protocop::Buffer#read_double ---->") do
      500_000.times do |n|
        buffer = Protocop::Buffer.new
        buffer.write_double(1.312)
        buffer.read_double
      end
    end

    GC.start

    bench.report("Protocop::Buffer#read_fixed32 --->") do
      500_000.times do |n|
        buffer = Protocop::Buffer.new
        buffer.write_fixed32(256)
        buffer.read_fixed32
      end
    end

    GC.start
  end
end
