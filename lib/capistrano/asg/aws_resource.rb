# frozen_string_literal: true

module Capistrano
  module Asg
    # Provides basic AWS resource methods
    class AWSResource
      include Capistrano::DSL
      include Capistrano::Asg::Aws::AutoScaling
      include Capistrano::Asg::Aws::EC2
      include Capistrano::Asg::Retryable
      include Logger

      attr_reader :aws_counterpart

      def cleanup(&_block)
        items = trash || []
        yield
        destroy items
        self
      end

      private

      def base_ec2_instance
        autoscaling_group.instances.first
      end

      def environment
        fetch(:rails_env, "production")
      end

      def timestamp(str)
        "#{str}-#{Time.now.utc.to_i}"
      end

      def deployed_with_asg?(resource)
        return false if resource.tags.empty?

        resource.tags.any? { |k| k.key == "deployed-with" && k.value == "cap-asg" } &&
          resource.tags.any? { |k| k.key == "cap-asg-deploy-group" && k.value == autoscaling_group_name }
      end
    end
  end
end
