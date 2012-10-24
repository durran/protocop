require "benchmark"

Benchmark.bm do |bench|

  bench.report("Protocop::Buffer#write_boolean") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_boolean(true)
    end
  end

  bench.report("Protocop::Buffer#write_double") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_double(n.to_f)
    end
  end

  bench.report("Protocop::Buffer#write_fixed64") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_fixed64(n)
    end
  end

  bench.report("Protocop::Buffer#write_float") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_float(n.to_f)
    end
  end

  bench.report("Protocop::Buffer#write_sfixed64") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_sfixed64(n)
    end
  end

  bench.report("Protocop::Buffer#write_sint32") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_sint32(n)
    end
  end

  bench.report("Protocop::Buffer#write_uint64") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_uint64(n)
    end
  end

  bench.report("Protocop::Buffer#write_string") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_string("#{n}")
    end
  end
end
