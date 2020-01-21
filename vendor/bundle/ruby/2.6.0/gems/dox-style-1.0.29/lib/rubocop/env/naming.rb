# frozen_string_literal: true

module RuboCop
  module Env
    class Naming < RuboCop::Cop::Cop
      REPLACEMENTS = {
        DOXIMITY_APP_URL: :DOXIMITY_URL,
        AUTH_URL: :AUTH_API_URL,
        DOXIMITY_AUTH_API_URL: :AUTH_API_URL,
        DOXIMITY_BRIDGE_DATABASE_URL: :BRIDGE_DATABASE_URL,
        DOXIMITY_WEB_HOST: :DOXIMITY_HOST,
        DOXIMITY_WEB_DEFAULT_PROTOCOL: :DOXIMITY_SCHEMA,
        DOXIMITY_WEB_TOP_LEVEL_HOST: :AUTH_TOP_LEVEL_COOKIE_DOMAIN
      }.freeze

      def_node_matcher :bad_node?, <<-PATTERN
        (send (const nil? :ENV) :fetch $#bad_pattern? ...)
      PATTERN

      def on_send(node)
        bad_node?(node) do
          add_offense(node, location: :selector, message: message(node))
        end
      end

      def bad_pattern?(node)
        REPLACEMENTS.key? node.children.first.to_sym
      end

      def message(node)
        "Use #{replacement(node)} instead. See https://wiki.doximity.com/articles/using-environment-variables#name-your-variables-consistently"
      end

      def autocorrect(node)
        lambda do |corrector|
          corrector.replace node.children[2].loc.expression,
                            %("#{replacement(node)}")
        end
      end

      def replacement(node)
        REPLACEMENTS[value(node)]
      end

      def value(node)
        node.children[2].children.first.to_sym
      end
    end
  end
end
