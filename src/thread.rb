require_relative './constants'
require_relative './basic_module'
require_relative './utils/thread_pool'

require 'etc'

class ThreadRun
  prepend BasicModule

  def run
    size = Etc.nprocessors
    pool = ThreadPool.new(size: size) { |file| BasicModule.process_file(file) }

    files.each { |file| pool << file }
    pool.join
  end
end

ThreadRun.new.run
