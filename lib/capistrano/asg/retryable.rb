# frozen_string_literal: true

module Capistrano
  module Asg
    module Retryable
      def with_retry(max: fetch(:asg_retry_max, 3), delay: fetch(:asg_retry_delay, 5))
        tries ||= 0
        tries += 1
        yield
      rescue StandardError => e
        raise e.message if tries < max

        puts "Rescued #{e.message}"
        puts "Retrying in #{delay} seconds..."
        sleep delay
        retry
      end
    end
  end
end
