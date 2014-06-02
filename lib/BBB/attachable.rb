module BBB
  module Attachable
    module ClassMethods

      def class_components
        @class_components ||= {}
      end

      def class_component_groups
        @class_component_groups ||= Hash.new { |hash, key| hash[key] = [] }
      end

      ##
      # Attach a component of a certain type to the circuit
      #
      # @param component [Class] The class of the object you # want to attach.
      # @param opts [Hash] Hash of options that setup the component
      #
      # @option opts [Symbol] :pin The pin position for the component
      # @option opts [Array<Symbol>] :pins The list of pin numbers used on the
      #     circuit.
      # @options opts [Symbol] :as The name of the component
      #
      def attach(object, opts={})
        name   = opts.delete(:as)
        group  = opts.delete(:group)

        class_components[name] = object
        define_method_for_object(object, name, opts)

        define_method_for_group(group)
        add_to_group(name, group) if group
      end

      def define_method_for_object(component, name, opts)
        define_method(name) do
          value = components[name]
          return value if value

          object = self.class.class_components[name]
          value = object.kind_of?(Class) ? object.new(opts) : object
          components[name] = value
        end
      end

      def define_method_for_group(group_name)
        return if group_name.nil? || respond_to?(group_name)
        define_method(group_name) do
          if component_groups[group_name].empty?
            component_groups[group_name] = self.class.class_component_groups[group_name]
          end

          component_groups[group_name].map do |component_name|
            self.send(component_name)
          end
        end
      end

      def add_to_group(component_name, group_name)
        class_component_groups[group_name] << component_name
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def components
      @components ||= {}
    end

    def component_groups
      @component_groups ||= Hash.new { |hash, key| hash[key] = [] }
    end
  end
end
