require "benchmark"

Benchmark.bm do |bench|

  bench.report("Protocop::Buffer#write_boolean") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_boolean(true)
    end
  end

  bench.report("Protocop::Buffer#write_float") do
    buffer = Protocop::Buffer.new
    2_000_000.times do |n|
      buffer.write_float(n.to_f)
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
