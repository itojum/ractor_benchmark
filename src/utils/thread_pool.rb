class ThreadPool
  def initialize(size:, &task)
    @queue = Queue.new

    @workers = size.times.map do
      Thread.new do
        while (item = @queue.pop)
          task.call(item)
        end
      end
    end
  end

  def <<(item)
    @queue << item
    self
  end

  def join
    @queue.close
    @workers.each(&:join)
  end
end
