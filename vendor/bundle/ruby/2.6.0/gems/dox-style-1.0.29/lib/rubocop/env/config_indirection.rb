# frozen_string_literal: true

module RuboCop
  module Env
    class ConfigIndirection < RuboCop::Cop::Cop
      MSG = "Configure things directly. See https://wiki.doximity.com/articles/using-environment-variables#don-t-configure-things-indirectly"

      def_node_matcher :env_call?, <<-PATTERN
        (send (const nil? :ENV) {:[] :fetch} $(str {"CLUSTER" "RAILS_ENV" "RACK_ENV"}) ...)
      PATTERN

      def_node_matcher :rails_dot_env_call?, <<-PATTERN
        (send (const nil? :Rails) :env)
      PATTERN

      def_node_matcher :dox_env_call?, <<-PATTERN
        (send (const (const nil? :Dox) :Env) {:[] :fetch} {(str {"CLUSTER" "RAILS_ENV" "RACK_ENV"}) (sym {:CLUSTER :RAILS_ENV :RACK_ENV})})
      PATTERN

      def on_send(node)
        return unless bad_node?(node)

        add_offense node, location: :selector, message: MSG
      end

      def bad_node?(node)
        env_call?(node) || rails_dot_env_call?(node) || dox_env_call?(node)
      end
    end
  end
end
