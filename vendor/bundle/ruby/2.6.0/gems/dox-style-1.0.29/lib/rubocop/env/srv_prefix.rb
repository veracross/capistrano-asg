# frozen_string_literal: true

module RuboCop
  module Env
    class SrvPrefix < RuboCop::Cop::Cop
      MSG = "Don't use SRV_ as a prefix for environment variables. See https://wiki.doximity.com/articles/using-environment-variables#prefixes-are-bad-suffixes-are-good"

      def_node_matcher :bad_node?, <<-PATTERN
        (send (const nil? :ENV) :fetch $#bad_pattern? ...)
      PATTERN

      def on_send(node)
        bad_node?(node) do
          add_offense node,
                      location: :selector,
                      message: MSG
        end
      end

      def bad_pattern?(node)
        node.children.first =~ /^SRV_/
      end

      def autocorrect(node)
        lambda do |corrector|
          corrector.replace node.children[2].loc.expression,
                            node.children[2].source.gsub(/SRV_/, "")
        end
      end
    end
  end
end
