# frozen_string_literal: true

module RuboCop
  module Migrations
    class ColumnOrdering < RuboCop::Cop::Cop
      MSG = "This causes trouble in Aurora and Snowflake. Use the default column ordering."

      def_node_matcher :method_call?, <<-PATTERN
        (send nil? {:add_column :remove_column :change_column}
          ...
          (hash
            $(pair
              (sym {:before :after})
              _
            )
            ...
          )
        )
      PATTERN

      def_node_matcher :block_call?, <<-PATTERN
        (send
          (lvar :t) :column
          _
          _
          (hash
            ...
            $(pair
              (sym {:before :after})
              _
            )
          )
        )
      PATTERN

      def_node_matcher :in_sql?, <<-PATTERN
        (send
          (lvar _) {:add_column :remove_column :change_column}
          ...
          $(str #bad_sql?)
        )
      PATTERN

      def on_send(node)
        matched = (method_call?(node) || block_call?(node) || in_sql?(node))
        add_offense(matched, message: MSG) if matched
      end

      def bad_sql?(node)
        node =~ / (after|before) /
      end
    end
  end
end
