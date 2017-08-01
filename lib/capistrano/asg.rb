require 'aws-sdk'
require 'capistrano/all'
require 'active_support/concern'

require 'capistrano/asg/version'
require 'capistrano/asg/retryable'
require 'capistrano/asg/taggable'
require 'capistrano/asg/logger'
require 'capistrano/asg/aws/credentials'
require 'capistrano/asg/aws/autoscaling'
require 'capistrano/asg/aws/ec2'
require 'capistrano/asg/aws_resource'
require 'capistrano/asg/ami'
require 'capistrano/asg/launch_configuration'

module Capistrano
  module Asg
  end
end

require 'aws-sdk'
require 'capistrano/dsl'

load File.expand_path('../asg/tasks/asg.rake', __FILE__)

def autoscale(groupname, *args)
  include Capistrano::DSL
  include Capistrano::Asg::Aws::AutoScaling
  include Capistrano::Asg::Aws::EC2

  autoscaling_group = autoscaling_resource.group(groupname)
  asg_instances = autoscaling_group.instances

  set :aws_autoscale_group, groupname
  region = fetch(:aws_region)
  regions = fetch(:regions, {})
  (regions[region] ||= []) << groupname
  set :regions, regions

  asg_instances.each do |asg_instance|
    if asg_instance.health_status != 'Healthy'
      puts "Autoscaling: Skipping unhealthy instance #{instance.id}"
    else
      ec2_instance = ec2_resource.instance(asg_instance.id)
      hostname = ec2_instance.private_ip_address
      puts "Autoscaling: Adding server #{hostname}"
      server(hostname, *args)
    end
  end

  if asg_instances.count > 0
    after('deploy', 'asg:scale')
  else
    puts 'Autoscaling: AMI could not be created because no running instances were found.\
      Is your autoscale group name correct?'
  end

  reset_autoscaling_objects
  reset_ec2_objects
end
