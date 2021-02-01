# frozen_string_literal: true

require "aws-sdk-ec2"
require "aws-sdk-autoscaling"
require "capistrano/all"
require "active_support/concern"

require "capistrano/asg/version"
require "capistrano/asg/retryable"
require "capistrano/asg/taggable"
require "capistrano/asg/logger"
require "capistrano/asg/aws/region"
require "capistrano/asg/aws/autoscaling"
require "capistrano/asg/aws/ec2"
require "capistrano/asg/aws_resource"
require "capistrano/asg/ami"
require "capistrano/asg/launch_configuration"

module Capistrano
  module Asg
    class EmptyAutoscalingGroup < StandardError; end
  end
end

require "capistrano/dsl"

load File.expand_path("asg/tasks/asg.rake", __dir__)

def autoscale(groupname, roles: [], partial_roles: [], **args)
  include Capistrano::DSL
  include Capistrano::Asg::Aws::AutoScaling
  include Capistrano::Asg::Aws::EC2
  include Capistrano::Asg::Retryable

  autoscaling_group = autoscaling_resource.group(groupname)
  asg_instances = autoscaling_group.instances

  if asg_instances.count.zero?
    puts "Autoscaling group has no instances"
    raise Capistrano::Asg::EmptyAutoscalingGroup
  end

  set :aws_autoscale_group, groupname
  region = fetch(:aws_region)
  regions = fetch(:regions, {})
  (regions[region] ||= []) << groupname
  set :regions, regions

  # Create an array of role names to be distributed across the ASG
  partial_queue = []
  partial_roles.each do |partial|
    instances = partial.key?(:instances) ? partial[:instances] : 1
    instances.times { partial_queue << partial[:name].to_s }
  end

  roles << "autoscale"

  # Collect all instance ids from healthy instances
  instance_ids = asg_instances.collect.each do |asg_instance|
    unless asg_instance.health_status == "Healthy"
      puts "Autoscaling: Skipping unhealthy instance #{asg_instance.id}"
      next
    end

    unless asg_instance.lifecycle_state == "InService"
      puts "Autoscaling: Skipping #{asg_instance.id}, lifecycle state is #{asg_instance.lifecycle_state}"
      next
    end

    asg_instance.instance_id
  end

  # Pull all instances with enumerator to avoid hitting rate limiting for querying private IP
  ec2_resource.instances(instance_ids: instance_ids.compact).each do |instance|
    hostname = instance.private_ip_address
    puts "Autoscaling: Adding server #{hostname}"
    host_roles = roles.dup
    if (additional_role = partial_queue.shift)
      host_roles << additional_role
    end
    server(hostname, roles: host_roles, **args)
  end

  puts "WARNING: Not all partial roles were assigned: #{partial_queue}" unless partial_queue.empty?

  if fetch(:create_ami, true)
    if asg_instances.count.positive?
      after("deploy:finishing", "asg:scale")
    else
      puts 'Autoscaling: AMI could not be created because no running instances were found.\
        Is your autoscale group name correct?'
    end
  end

  reset_autoscaling_objects
  reset_ec2_objects
end
