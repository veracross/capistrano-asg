require 'capistrano/asg'

namespace :asg do
  task :scale do
    set :aws_access_key_id,     fetch(:aws_access_key_id,     ENV['AWS_ACCESS_KEY_ID'])
    set :aws_secret_access_key, fetch(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
    asg_launch_config = {}

    # Iterate over relevant regions
    regions = fetch(:regions)
    regions.keys.each do |region|
      set :aws_region, region
      asg_launch_config[region] = {}

      # Iterate over relevant ASGs
      regions[region].each do |asg|
        set :aws_autoscale_group, asg
        Capistrano::Asg::AMI.create do |ami|
          puts "Autoscaling: Created AMI: #{ami.aws_counterpart.id} from region #{region} in ASG #{asg}"
          Capistrano::Asg::LaunchConfiguration.create(ami) do |lc|
            puts "Autoscaling: Created Launch Configuration: #{lc.aws_counterpart.name} from region #{region} in ASG #{asg}"
            asg_launch_config[region][asg] = lc.aws_counterpart.name
            lc.attach_to_autoscale_group!
          end
        end
      end
    end

    set :asg_launch_config, asg_launch_config
  end
end
