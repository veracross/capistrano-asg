# frozen_string_literal: true

module Capistrano
  module Asg
    # Create launch configuration
    class LaunchConfiguration < AWSResource
      attr_reader :region_config

      def self.create(ami, region_config = {}, &_block)
        lc = new(region_config)
        lc.cleanup do
          lc.save(ami)
          yield lc
        end
      end

      def initialize(region_config = {})
        @region_config = region_config
      end

      def save(ami)
        info "Creating an EC2 Launch Configuration for AMI: #{ami.aws_counterpart.id}"

        with_retry do
          ec2_instance = ec2_resource.instance(base_ec2_instance.id)
          @aws_counterpart = autoscaling_resource.create_launch_configuration(
            launch_configuration_name: name,
            image_id: ami.aws_counterpart.id,
            instance_type: instance_size,
            security_groups: ec2_instance.security_groups.map(&:group_id),
            associate_public_ip_address: region_config.fetch(:aws_launch_configuration_associate_public_ip, true),
            instance_monitoring: {
              enabled: fetch(:aws_launch_configuration_detailed_instance_monitoring, true)
            },
            user_data: region_config.fetch(:aws_launch_configuration_user_data, nil),
            iam_instance_profile: ec2_instance.iam_instance_profile.arn
          )
        end
      end

      def attach_to_autoscale_group!
        info "Attaching Launch Configuration #{aws_counterpart.name} to AutoScaling Group #{autoscaling_group.name}"
        autoscaling_group.update(
          launch_configuration_name: aws_counterpart.name
        )
      end

      def destroy(launch_configurations = [])
        launch_configurations.each do |lc|
          info "Deleting old Launch Configuration: #{lc.name}"
          lc.delete
        end
      end

      private

      def name
        timestamp region_config.fetch(:aws_lc_name_prefix, "cap-asg-#{environment}-#{autoscaling_group_name}-lc")
      end

      def instance_size
        region_config.fetch(:aws_autoscale_instance_size, "m1.small")
      end

      def deployed_with_asg?(launch_config)
        launch_config.name.include? region_config.fetch(:aws_lc_name_prefix, "cap-asg-#{environment}-#{autoscaling_group_name}-lc")
      end

      def trash
        autoscaling_resource.launch_configurations.to_a.select do |lc|
          deployed_with_asg? lc
        end
      end
    end
  end
end
