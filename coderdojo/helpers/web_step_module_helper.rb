module WebStepModuleHelper

  def self.create_helper_module(module_helper_name)
    return ModuleHelperCreator.new(module_helper_name).create_helper_module
  end

  class ModuleHelperCreator

    def initialize(module_helper_name)
      @module_helper_name = module_helper_name
      @helper_module_name = "#{@module_helper_name}Helpers"
      @steps_dir = File.expand_path(File.dirname(__FILE__) + '/../step_definitions')
      @view_impls = {}
      YAML.load_file(File.expand_path(File.dirname(__FILE__) +
                                        '/../../config/view_impls.yml'))['view_impl'].each do |k, v|
        @view_impls[v] = nil if k.end_with?('web')
      end
    end

    def self.message
      return "If using this, any module being extended by the module this factory provides " +
             "needs to have its methods be instance methods."
    end

    def create_helper_module
      puts(Colored.colorize(
        "Creating #{@helper_module_name} Class/Module\n#{self.class.message}").blue) if ENV['DEBUG_MODE'].to_bool
      set_module_impl_files
      return create_module
    end

    private
    def create_module
      base = Module.new
      full_module_name = "#{@helper_module_name}::#{@module_helper_name}"
      base.extend ::RSpec::Matchers # Let RSpec expect() work in implementation files.
      unless @view_impls['Template'].nil?
        require_relative @view_impls['Template']
        base.extend "#{full_module_name}Template".constantize
      else
        raise LoadError, Colored.colorize("#{@helper_module_name} Template file not found. Aborting...").bold.red
      end

      @view_impls.keys.each do |key|
        next if key == 'Template'
        if ENV['VIEW_IMPL'] == key.underscore && !@view_impls[key].nil?
          require_relative @view_impls[key]
          base.extend "#{full_module_name}#{key}".constantize
        else
          # Don't really need to do anything. Just print message and let fall through to template lookup.
          puts Colored.colorize("#{@module_helper_name}: No implementation for #{key.underscore}. " +
                  "Perhaps you should implement steps for this site type.").blue if ENV['DEBUG_MODE'].to_bool
        end
      end
      return base
    end

    private
    def set_module_impl_files
      # Get impl files.
      @view_impls.keys.each do |impl_key|
        Dir["#{@steps_dir}/**/*_#{impl_key.underscore}.rb"].each do |impl_file|
          module_name = "#{@module_helper_name}#{impl_key}"
          if File.foreach(impl_file).first(5).to_s.match(/module +#{module_name}/)
            @view_impls[impl_key] = impl_file.to_s
            impl = File.basename(impl_file).to_s
            unless impl.to_s == "#{module_name.underscore}.rb"
              raise Colored.colorize("Source file #{impl} name does not adhere to class/module name: #{module_name} " +
                      "=> #{module_name.underscore}.rb").bold.red
            end
          end
        end
      end
    end
  end
  private_constant(:ModuleHelperCreator)
end
