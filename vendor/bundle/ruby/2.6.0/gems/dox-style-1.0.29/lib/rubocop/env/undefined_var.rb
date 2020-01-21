# frozen_string_literal: true

module RuboCop
  module Env
    class UndefinedVar < RuboCop::Cop::Cop
      IGNORED = %w[
        CIRCLECI
        CIRCLE_ARTIFACTS
        CIRCLE_BRANCH
        CIRCLE_BUILD_NUM
        CIRCLE_NODE_INDEX
        CIRCLE_NODE_TOTAL
        CIRCLE_PROJECT_REPONAME
        COVERAGE
        PORT
        RAILS_ENV
        RAKE_ENV
        TEST_ENV_NUMBER
      ].freeze
      MSG = "This environment variable needs to be defined in .env.development and .env.test."

      def_node_matcher :bad_node?, <<-PATTERN
        (send (const nil? :ENV) :fetch $#bad_pattern? ...)
      PATTERN

      def on_send(node)
        bad_node?(node) do |n|
          add_offense n, location: :expression, message: MSG
        end
      end

      def bad_pattern?(node)
        return if IGNORED.include?(node.children.first)

        !valid_vars.include?(node.children.first)
      end

      def valid_vars
        @valid_vars ||= (env("development") + env("test")).sort.uniq
      end

      def env(name)
        fname = File.join(root_of(processed_source.path), ".env.#{name}")
        return [] unless File.exist? fname

        File.read(fname).
          split(/\n/).
          select { |l| l =~ /^[^#]/ }.
          map { |l| l.split(/=/).first }
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
