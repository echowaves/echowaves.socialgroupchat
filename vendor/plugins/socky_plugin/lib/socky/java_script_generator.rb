require 'action_view'

module Socky
  class JavaScriptGenerator
    include ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods

    def initialize(&block)
      @lines = []

      case Rails::VERSION::MAJOR
      when 2
        @context = eval("self.instance_variable_get('@template')", block.binding)
        block.call(self)
        unless @context.nil?
          @context.controller.response.body = nil
          @context.controller.instance_variable_set("@performed_render",false)
        end
      when 3
        @context = eval("self.view_context", block.binding)
        block.call(self)
        @context.controller.instance_variable_set("@_response_body",nil) unless @context.nil?
      end
    end

  end
end