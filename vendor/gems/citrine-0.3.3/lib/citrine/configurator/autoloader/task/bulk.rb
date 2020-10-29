# frozen-string-literal: true
module Citrine
  module Configurator
    module Autoloader
      module Task
        class Bulk < Base
          def config_data
            data.inject({}) do |config, (name, scheme)|
              config[transform_key(name)] = scheme[:config][:data]
              config
            end
          end
          
          protected

          def transform_key(name)
            options[:transform_key].nil? ? name : name.send(options[:transform_key])
          end

          def load_scheme!
            autoloader.refresh_schemes(scheme_params)
          end

          def process_result(result)
            Utils.deep_clone(result.data[:update]).each do |scheme|
              deserialize_scheme_config(scheme[:config])
              @data[scheme[:name]] = scheme
            end
            result.data[:remove].each { |name| @data.delete(name) }
            scheme_params[:base] = 
              @data.map do |name, scheme|
                  { name: name, config_id: scheme[:config][:id] }
              end
            @scheme_tag = "total: #{scheme_params[:base].size}; " +
                          "updated: #{result.data[:update].size}; " + 
                          "removed: #{result.data[:remove].size}"
            @scheme = "#{@scheme_name} (#{scheme_tag})"
          end
        end
      end
    end
  end
end
