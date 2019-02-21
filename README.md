# capistrano-asg

This is a fork of [lserman/capistrano-elbas](https://github.com/lserman/capistrano-elbas), updated with new features and Capistrano 3 conventions.

capistrano-asg was written to ease the deployment of Rails applications to AWS AutoScale groups. capistrano-asg will:

- Deploy your code to each running instance connected to a given AutoScale group
- After deployment, create an AMI from one of the running instances
- Attach the AMI with the new code to a new AWS Launch Configuration
- Update your AutoScale group to use the new launch configuration
- Delete any old AMIs created by capistrano-asg
- Delete any old launch configurations created by capistrano-asg

This ensures that your current and future servers will be running the newly deployed code.

## Installation

`gem 'capistrano-asg'`

Add this statement to your Capfile:

`require 'capistrano/asg'`

## Configuration

Below are the Capistrano configuration options with their defaults:

```ruby
set :aws_access_key_id,     ENV['AWS_ACCESS_KEY_ID']
set :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']
set :aws_region,            ENV['AWS_REGION']

# To set region specific things:
set "#{ENV['AWS_REGION']}_#{asg}".to_sym, {
  aws_no_reboot_on_create_ami: true,
  aws_autoscale_instance_size: 'm1.small',
  aws_launch_configuration_detailed_instance_monitoring: true,
  aws_launch_configuration_associate_public_ip: true
}

```

where `asg` is the name of the autoscaling group in the given region.

## Usage

Instead of using Capistrano's `server` method, use `autoscale` instead in `deploy/production.rb` (or
whichever environment you're deploying to). Provide the name of your AutoScale group instead of a
hostname:

```ruby
autoscale 'production', user: 'apps', roles: [:app, :web, :db]
```

If you have multiple autoscaling groups to deploy to, specify each of them:

```ruby
autoscale 'asg-app', user: 'apps', roles: [:app, :web]
autoscale 'asg-db', user: 'apps', roles: [:db]
```

Similarly, if you are deploying to multiple regions and/or multiple ASGs:

```ruby
asgs    = %w(asg1 asg2)
regions = %w(us-east-1 eu-west-1)

asgs.each do |asg|
  regions.each do |region|
    set :aws_region, region
    set "#{region}_#{asg}".to_sym, {
      aws_autoscale_instance_size: 't2.medium'
      ...
    }
    autoscale asg, user: 'apps', roles: [:app, :web, :db]
  end
end
```

The name of the newly created launch configurations are available via `fetch(:asg_launch_config)`.
This is a two-dimensional hash with region and autoscaling group name as keys.
You can output these or store them as necessary in an `after 'deploy:finished'` hook.
An example value is:

```
{
  'us-east-1' => {
    'asg-app' => 'cap-asg-production-app-server-private-asg-lc-1501619456'
  },
  'eu-west-1' => {
    'asg-app' => 'cap-asg-production-app-server-private-asg-lc-1501619454'
  }
}
```

That's it! Run `cap production deploy`. The following log statements are printed
during deployment:

```
Autoscaling: Adding server: ec2-XX-XX-XX-XXX.compute-1.amazonaws.com
Autoscaling: Creating EC2 AMI from i-123abcd
Autoscaling: Created AMI: ami-123456
Autoscaling: Creating an EC2 Launch Configuration for AMI: ami-123456
Autoscaling: Created Launch Configuration: cap-asg-lc-ENVIRONMENT-UNIX_TIMESTAMP
Autoscaling: Attaching Launch Configuration to AutoScale Group
Autoscaling: Deleting old launch configuration: cap-asg-lc-production-123456
Autoscaling: Deleting old image: ami-999999
```
