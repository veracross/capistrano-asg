# frozen_string_literal: true

module RuboCop
  module Env
    class UseFetch < RuboCop::Cop::Cop
      MSG = "Use ENV.fetch instead of []. See https://wiki.doximity.com/articles/using-environment-variables#fail-as-fast-as-possible"

      def_node_matcher :env_access?, <<-PATTERN
          (send (const nil? :ENV) :[] _ )
      PATTERN

      def on_send(node)
        env_access?(node) do
          add_offense(node, location: :selector, message: MSG)
        end
      end

      def autocorrect(node)
        return unless should_correct?(node)

        lambda do |corrector|
          return replace_truthy_with_key_check(corrector, node) if truthy_check?(node)
          return replace_present_with_key_check(corrector, node) if present_check?(node)
          return replace_with_fetch_with_default(corrector, node) if or?(node)
        end
      end

      def should_correct?(node)
        !or_assign?(node) && (truthy_check?(node) || present_check?(node) || or?(node))
      end

      def or_assign?(node)
        node.parent&.or_asgn_type?
      end

      def truthy_check?(node)
        node.parent&.if_type? && node.parent&.children&.index(node)&.zero?
      end

      def present_check?(node)
        (node.parent&.send_type? && node.parent.children.last == :present?)
      end

      def replace_truthy_with_key_check(corrector, node)
        corrector.replace(node.loc.expression, key_check_expr(node))
      end

      def replace_present_with_key_check(corrector, node)
        corrector.replace(node.parent.loc.expression, key_check_expr(node))
      end

      def key_check_expr(node)
        %[ENV.key?(#{node.arguments[0].source})]
      end

      def or?(node)
        node.parent&.or_type?
      end

      def replace_with_fetch_with_default(corrector, node)
        corrector.replace(
          node.parent.loc.expression,
          %[ENV.fetch(#{node.arguments[0].source}, #{node.parent.children.last.source})]
        )
      end
    end
  end
end
