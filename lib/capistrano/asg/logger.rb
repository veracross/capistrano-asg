# frozen_string_literal: true

module Capistrano
  module Asg
    module Logger
      def info(message)
        puts "Autoscaling: #{message}"
      end
    end
  end
end
