class Runner
  # run the commands in the dir
  def self.run(dir, command)
    Rails.logger.debug("[BOB] Running #{command} in #{dir}")

    commands = [ 
      "cd #{dir}",
      "#{command}"
    ]

    # auto source a .bobrc file if one exists in the dir
    commands.insert(1,"source .bobrc") if File.exists?(File.join(dir,
    '.bobrc'))

    output = ''
    error = ''
    command = commands.join(' && ')
    clean_env do
      status = Open4.popen4(command) do |pid, stdin, stdout, stderr|
        #puts stdout.read
        while !stdout.eof? or !stderr.eof?
          output += stdout.read
          output += stderr.read
          error  += stderr.read
        end
      end
      unless status.exitstatus == 0
        message = "Error (#{status.exitstatus}) executing '#{command}' in '#{dir}'"
        Rails.logger.debug(message)
        raise RunnerError.new(output, message)
      end
      output
    end
  end

  def self.clean_env(&blk )
    # clean up some vars
    swap_env = {
      'BUNDLE_GEMFILE' => ENV['BUNDLE_GEMFILE'],
      'RAILS_ENV' => ENV['RAILS_ENV'],
      'BUNDLE_PATH' => ENV['BUNDLE_PATH'],
      'GEM_PATH' => ENV['GEM_PATH'],
      'RUBYOPT' => ENV['RUBYOPT']
    }    
    ENV['GEM_PATH'] = nil
    ENV['RUBYOPT'] = nil
    ENV['RAILS_ENV'] = 'test'
    ENV['BUNDLE_GEMFILE'] = nil
    ENV['BUNDLE_PATH'] = nil

    result = blk.call
    result
  ensure
    # Put the original vars back into play
    swap_env.each do |key,value|
      ENV[key] = value
    end
  end


end


class RunnerError < Exception
  attr_reader :output

  def initialize(output, message)
    @output = output
  end
end
