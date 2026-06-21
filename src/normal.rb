require_relative './constants'
require_relative './basic_module'

require 'etc'

class ThreadRun
  prepend BasicModule

  def run
    files.each do |file|
      BasicModule.process_file(file)
    end
  end
end

ThreadRun.new.run
