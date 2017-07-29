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
