require_relative './constants'
require_relative './basic_module'
require_relative './utils/ractor_pool'

require 'etc'

class RactorRun
  prepend BasicModule

  TASK = Ractor.make_shareable(-> (file) { BasicModule.process_file(file) })

  def run
    size = Etc.nprocessors
    pool = RactorPool.new(size: size, &TASK)

    files.each { |file| pool << file }
    pool.join
  end
end

RactorRun.new.run
