class String
  # Coloring strings according to color scheme.
  def yabe_colored(color)
    case color
    when :yabe
      "\e[36m" + self + "\e[0m"
    when :error
      "\e[31m" + self + "\e[0m"
    end
  end

  # Escaping string for use in shell.
  def shell_escaped
    "'" + self.gsub("'") do |c|
      "'" + '\\' + "'" + "'"
    end + "'"
  end
end

module YABE
  # Class for executing commands with custom options.
  class Executor
    # Possible options:
    # quiet: executes withou output
    # extra_message: outputs an extra message specified
    # step: requires <Enter> to continue
    # force: carries on even after an error
    
    # It is possible to initialize with default options.
    def initialize(default_options: {})
      @default_options = default_options
    end

    # It is also possible to execute a command with different options.
    def execute(array, options={})
      options = @default_options.merge(options)

      command_string = array.map do |word|
        word.shell_escaped
      end.join(' ')

      unless options[:quiet]
        print 'Execute: '.yabe_colored(:yabe)
        puts command_string
      end

      if options[:extra_message]
        puts options[:extra_message].yabe_colored(:yabe)
      end

      if options[:quiet]
        `#{command_string}`
      else
        system command_string
      end

      unless $?.success? || options[:force]
        YABE.raise_error(
          'An error occured and the install paused.'\
          ' Press Enter to continue, or Ctrl-c to exit.',
          exit_script: false
        )
        STDIN.gets
      else
        unless options[:quiet]
          puts 'DONE'.yabe_colored(:yabe)
          options[:step]? STDIN.gets : puts
        end
      end

    end
  end

  # Writes data to file for use in multiple scripts.
  module_function
  def primitive_object_to_file(name, object, filename)
    content = File.exists?(filename)? File.open(filename, 'r') do |file|
      file.readlines[1...-1]
    end : []

    content << name + ' = ' + object.inspect
    File.write(filename, "module Vars\n"+content.join+"\nend")
  end

  # Raises custom error.
  module_function
  def raise_error(message, type: :error, exit_script: true)
    case type
    when :error
      STDERR.print 'ERROR: '.yabe_colored(:error)
    when :interruption
      STDERR.print 'INTERRUPTION: '.yabe_colored(:error)
    end
    STDERR.puts message
    exit 1 if exit_script
  end
end
