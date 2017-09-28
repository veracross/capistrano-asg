require 'capistrano/asg'

namespace :asg do
  task :scale do
    set :aws_access_key_id,     fetch(:aws_access_key_id,     ENV['AWS_ACCESS_KEY_ID'])
    set :aws_secret_access_key, fetch(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
    asg_launch_config = {}
    asg_ami_id = {}

    # Iterate over relevant regions
    regions = fetch(:regions)
    regions.keys.each do |region|
      set :aws_region, region
      asg_launch_config[region] = {}
      asg_ami_id[region] = {}

      # Iterate over relevant ASGs
      regions[region].each do |asg|
        set :aws_autoscale_group, asg
        Capistrano::Asg::AMI.create do |ami|
          puts "Autoscaling: Created AMI: #{ami.aws_counterpart.id} from region #{region} in ASG #{asg}"
          Capistrano::Asg::LaunchConfiguration.create(ami, fetch(region.to_sym, {})) do |lc|
            puts "Autoscaling: Created Launch Configuration: #{lc.aws_counterpart.name} from region #{region} in ASG #{asg}"
            asg_launch_config[region][asg] = lc.aws_counterpart.name
            asg_ami_id[region][asg] = ami.aws_counterpart.id
            lc.attach_to_autoscale_group!
          end
        end
      end
    end

    set :asg_launch_config, asg_launch_config
    set :asg_ami_id, asg_ami_id
  end
end
