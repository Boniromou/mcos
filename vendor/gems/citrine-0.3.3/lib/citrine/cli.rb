# frozen-string-literal: true
require "optparse"
require "pathname"

module Citrine
  def self.run_cli(mod, &blk)
    create_cli(mod).new(&blk).run
  end

  def self.create_cli(mod)
    if mod.const_defined?("CLI")
      mod.const_get("CLI")
    else
      mod.const_set("CLI", Class.new(Citrine::CLI))
    end
  end

  class CLI
    include Utils::BaseObject
    include Utils::Namespace

    class << self
      def inherited(subclass)
        super
        # Ensure operations from the base class
        # got inherited to its subclasses
        operations.each_pair do |name, description|
          subclass.operation(name, description)
        end
      end

      def operations; @operations ||= {}; end

      def operation(name, description)
        operations[name] = description
        operation_method = "run_#{name}"
        unless method_defined?(operation_method)
          define_method(operation_method) do
            launch_manager
            wait_for_signal
          rescue Interrupt
            get_manager.supervisor.terminate
          end
        end
      end
    end

    attr_reader :config_files

    operation :migration, "Run database migration"
    operation :service, "Start service"
    operation :jobs, "Start jobs"

    def default_signals
      %w(INT TERM USR1 USR2 TTIN TTOU)
    end

    def run
      parse_options
      parse_operation
      run_operation
    end

    def operations
      self.class.operations.keys
    end

    def parser
      @parser ||= create_parser
    end

    protected

    def on_init
      @options[:init_config_files] ||= []
      @options[:config_files] = []
    end

    def post_init
      setup_signal_handler
    end

    def setup_signal_handler
      @self_read, @self_write = IO.pipe
      default_signals.each do |sig|
        begin
          trap sig do
            @self_write.puts(sig)
          end
        rescue ArgumentError
          puts "Signal #{sig} not supported"
        end
      end
    end

    def create_parser
      OptionParser.new do |parser|
        add_parser_bannder(parser)
        add_parser_options(parser)
        parser.separator("")
        add_parser_operations(parser)
      end
    end

    def add_parser_bannder(parser)
      parser.banner = "Usage: #{$0} [options] [#{operations.join("|")}]"
    end

    def add_parser_options(parser)
      parser.on("-c", "--config CONFIG_FILE", 
                "Configuration file in YAML (default: config.yml)") do |config_file|
        options[:config_files] << config_file
      end
      parser.on("-h", "--help", "Show this message") do
        puts parser
        exit
      end
    end

    def add_parser_operations(parser)
      parser.separator("Commands:")
      self.class.operations.each_pair do |name, description|
        parser.separator("    #{name}\t\t#{description}")
      end
    end

    def parse_options
      parser.parse!
      set_default_config_files
    end

    def set_default_config_files
      if options[:config_files].empty?
        base_config_file = Pathname.pwd.join("config", "config.yml")
        options[:config_files] << base_config_file
      end
      unless options[:init_config_files].empty?
        options[:config_files] = 
          options[:init_config_files].concat(options[:config_files])
      end
      options[:config_files].each do |config_file|
        unless File.file?(config_file)
          abort "Error!! Config file NOT found: #{config_file}"
        end
      end
    end

    def parse_operation
      options[:operation] = (ARGV[0] || "service").to_sym
      unless operations.include?(options[:operation])
        abort "Error!! Operation must be: #{operations.join(", ")}"
      end
      parse_operation_options = "parse_operation_#{options[:operation]}"
      send(parse_operation_options) if respond_to?(parse_operation_options, true)
    end

    def parse_operation_migration
      options[:migration_command] = ARGV[1]
    end

    def parse_operation_jobs
      options[:job_filter] = ARGV[1]
    end

    def run_operation
      send("run_#{options[:operation]}")
    end

    def launch_manager
      create_manager.launch(**options)
    end

    def create_manager
      get_or_set_constant("Manager", namespace: namespace_module, 
                          base: Citrine::Manager)
    end

    def get_manager
      get_constant("Manager", namespace: namespace_module)
    end

    def wait_for_signal
      while readable_io = IO.select([@self_read])
        signal = readable_io.first[0].gets.strip
        handle_signal(signal)
      end
    end

    def handle_signal(sig)
      send("handle_signal_#{sig.downcase}")
    end

    def handle_signal_int; raise Interrupt; end
    alias_method :handle_signal_term, :handle_signal_int

    def handle_signal_usr1; end
    def handle_signal_usr2; end
    def handle_signal_ttin; end
    def handle_signal_ttou; end
  end
end