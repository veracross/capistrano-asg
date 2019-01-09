require 'aws-sdk-ec2'
require 'aws-sdk-autoscaling'
require 'capistrano/all'
require 'active_support/concern'

require 'capistrano/asg/version'
require 'capistrano/asg/retryable'
require 'capistrano/asg/taggable'
require 'capistrano/asg/logger'
require 'capistrano/asg/aws/region'
require 'capistrano/asg/aws/autoscaling'
require 'capistrano/asg/aws/ec2'
require 'capistrano/asg/aws_resource'
require 'capistrano/asg/ami'
require 'capistrano/asg/launch_configuration'

module Capistrano
  module Asg
  end
end

require 'capistrano/dsl'

load File.expand_path('../asg/tasks/asg.rake', __FILE__)

def autoscale(groupname, roles: [], partial_roles: [], **args)
  include Capistrano::DSL
  include Capistrano::Asg::Aws::AutoScaling
  include Capistrano::Asg::Aws::EC2
  include Capistrano::Asg::Retryable

  autoscaling_group = autoscaling_resource.group(groupname)
  asg_instances = autoscaling_group.instances

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

  asg_instances.each do |asg_instance|
    if asg_instance.health_status != 'Healthy'
      puts "Autoscaling: Skipping unhealthy instance #{asg_instance.id}"
    else
      with_retry do
        ec2_instance = ec2_resource.instance(asg_instance.id)
        hostname = ec2_instance.private_ip_address
        puts "Autoscaling: Adding server #{hostname}"
        host_roles = roles.dup
        if additional_role = partial_queue.shift
          host_roles << additional_role
        end
        server(hostname, roles: host_roles, **args)
      end
    end
  end

  puts "WARNING: Not all partial roles were assigned: #{partial_queue}" unless partial_queue.empty?

  if fetch(:create_ami, true)
    if asg_instances.count > 0
      after('deploy:finishing', 'asg:scale')
    else
      puts 'Autoscaling: AMI could not be created because no running instances were found.\
        Is your autoscale group name correct?'
    end
  end

  reset_autoscaling_objects
  reset_ec2_objects
end
