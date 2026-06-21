class MemoryTracker
  INTERVAL = 0.05

  def initialize
    @samples = []
    @running = false
  end

  def start
    @t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @running = true
    @thread = Thread.new do
      while @running
        t = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - @t0).round(3)
        @samples << { t: t, rss_kb: sample_rss }
        sleep INTERVAL
      end
    end
    self
  end

  def stop
    @running = false
    @thread&.join
    self
  end

  def peak_rss_kb
    @samples.map { _1[:rss_kb] }.max.to_i
  end

  private

  def sample_rss
    pid = Process.pid
    `ps -Ao pid=,ppid=,rss= 2>/dev/null`.lines.sum { |l|
      p, pp, rss = l.split.map(&:to_i)
      (p == pid || pp == pid) ? rss : 0
    }
  end
end
