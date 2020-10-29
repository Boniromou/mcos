# frozen-string-literal: true
module Citrine
  module Warden
    class Base < Citrine::Interactor::Base
      def self.default_operation_namespace
        "Operations"
      end

      attr_reader :type
      attr_reader :authorizers_by_name
      attr_reader :authorizers_by_id

      operation :sign_request
      operation :authorize_request

      def find_authorizer_by_name(name)
        authorizers_by_name[name.respond_to?(:to_sym) ? name.to_sym : name]
      end

      def find_authorizer_by_id(id)
        authorizers_by_id[id.respond_to?(:to_sym) ? id.to_sym : id]
      end

      protected

      def on_init
        super
        @type = options[:type]
        @authorizers_by_name = {}
        @authorizers_by_id = {}
      end

      def post_init
        super
        create_authorizers if options[:authorizers]
      end

      def operations_module(operations_namespace)
        self.class.const_get(operations_namespace)
      end

      def create_authorizers
        options[:authorizers].each_with_object(authorizers_by_name) do |(name, spec), authorizers|
          authorizer = authorizer_class(name, spec[:type]).new(spec)
          authorizers_by_name[name] = authorizer
          id = spec[:access_key_id]
          authorizers_by_id[id.respond_to?(:to_sym) ? id.to_sym : id] = authorizer
        end
      end

      def authorizer_class(name, type)
        authorizers_module.const_get(type)
      end

      def authorizers_module
        @authorizers_module ||= create_authorizers_module
      end

      def create_authorizers_module
        get_or_set_constant(
          "Authorizers", 
          namespace: "#{self.class.name.split("::").first}".constantize, 
          base: Module
        )
      end

      def inject_dependencies_to_operation(operation)
        super
        inject_warden_to_operation(operation)
      end

      def inject_warden_to_operation(operation)
        operation.warden = self
      end
    end
  end
end
