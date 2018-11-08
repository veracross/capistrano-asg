module Capistrano
  module Asg
    module Retryable
      def with_retry(max: fetch(:asg_retry_max, 3), delay: fetch(:asg_retry_delay, 5))
        tries ||= 0
        tries += 1
        yield
      rescue => e
        puts "Rescued #{e.message}"
        if tries < max
          puts "Retrying in #{delay} seconds..."
          sleep delay
          retry
        else
          raise e.message
        end
      end
    end
  end
end
