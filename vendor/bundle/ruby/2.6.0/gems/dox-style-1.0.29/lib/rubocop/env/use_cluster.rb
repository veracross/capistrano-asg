# frozen_string_literal: true

module RuboCop
  module Env
    class UseCluster < RuboCop::Cop::Cop
      MSG = "Use Dox::Env.cluster instead of ENV[CLUSTER] directly. See https://wiki.doximity.com/articles/using-environment-variables#use-dox-env"

      def_node_matcher :cluster_access?, <<-PATTERN
        (send (const nil? :ENV) {:fetch :[]} (str "CLUSTER") ...)
      PATTERN

      def on_send(node)
        cluster_access?(node) do
          add_offense(node, location: :selector, message: MSG)
        end
      end

      def autocorrect(node)
        lambda do |corrector|
          corrector.replace(*correction(node))
        end
      end

      private

      def correction(node)
        if str_comp?(node)
          [node.parent.loc.expression, predicate_call(node)]
        else
          [node.loc.expression, "Dox::Env.cluster"]
        end
      end

      def predicate_call(node)
        "#{"!" if node.parent.method_name == :!=}Dox::Env.cluster.#{node.parent.children.last.value.underscore}?"
      end

      def str_comp?(node)
        node.parent &&
          %i[== !=].include?(node.parent.method_name) &&
          node.parent.children.last.str_type?
      end
    end
  end
end
