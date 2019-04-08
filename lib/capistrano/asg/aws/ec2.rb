# frozen_string_literal: true

module Capistrano
  module Asg
    module Aws
      # Provide EC2 client and resource information
      module EC2
        extend ActiveSupport::Concern
        include Region
        include Capistrano::DSL

        def ec2_resource
          @ec2_resource ||= ::Aws::EC2::Resource.new(client: ec2_client)
        end

        def reset_ec2_objects
          @ec2_resource = nil
        end

        private

        def ec2_client
          ::Aws::EC2::Client.new(region: region)
        end
      end
    end
  end
end
