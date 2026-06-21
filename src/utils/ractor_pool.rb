class RactorPool
  def initialize(size:, &task)
    @size = size
    @task = task
    @items = []
  end

  def <<(item)
    @items << item
    self
  end

  def join
    slice_size = (@items.size.to_f / @size).ceil

    workers = @items.each_slice(slice_size).map do |chunk|
      Ractor.new(chunk, @task) do |items, task|
        items.each { |item| task.call(item) }
      end
    end

    workers.each(&:join)
  end
end
