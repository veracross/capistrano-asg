# frozen_string_literal: true

module RuboCop
  module Env
    class OutsideConfig < RuboCop::Cop::Cop
      IGNORE_PATHS = [
        "bin",
        "config",
        "spec/rails_helper"
      ].freeze

      MSG = "Don't use ENV outside of the /config dir. See https://wiki.doximity.com/articles/using-environment-variables#keep-usage-localized"

      def_node_matcher :env_access?, <<-PATTERN
        (const nil? :ENV)
      PATTERN

      def on_const(node)
        env_access?(node) do
          add_offense(node, message: MSG) unless ignored?
        end
      end

      def ignored?
        path = processed_source.path
        root = root_of(path)

        IGNORE_PATHS.any? do |ignored|
          path.start_with? File.join(root, ignored)
        end
      end

      def root_of(path)
        return "" if path.nil? || path == "/"

        current = File.dirname(path)
        gemfile = File.join(current, "Gemfile")

        return current if File.exist?(gemfile)

        root_of(File.dirname(path))
      end
    end
  end
end
