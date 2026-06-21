require_relative './constants'
require_relative './basic_module'
require_relative './utils/process_pool'

require 'etc'

class ForkRun
  prepend BasicModule

  def run
    size = Etc.nprocessors
    pool = ProcessPool.new(size: size) { |file| BasicModule.process_file(file) }

    files.each { |file| pool << file }
    pool.join
  end
end

ForkRun.new.run
