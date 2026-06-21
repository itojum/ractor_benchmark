class ProcessPool
  def initialize(size:, &task)
    @workers = size.times.map do
      reader, writer = IO.pipe
      pid = Process.fork do
        writer.close
        while (line = reader.gets)
          task.call(line.chomp)
        end
        reader.close
      end
      reader.close
      { pid: pid, writer: writer }
    end
    @cursor = 0
  end

  def <<(item)
    @workers[@cursor % @workers.size][:writer].puts(item)
    @cursor += 1
    self
  end

  def join
    @workers.each { |w| w[:writer].close }
    Process.waitall
  end
end
