Changelog
=========

## 0.9.2

* Add an autoscale role

## 0.9.1

* Check the lifecycle state before including an instance

## 0.9.0

* Publish to jfrog with rubocop updates

## 0.8.1

* Use the default aws-sdk credential search order to use instance profiles
  or assumed roles

## 0.8.0

* Wrap EC2 calls with retries
* Adds `partial_roles` to run on a subset of instances in the ASG

## 0.7.0

* Update to AWS SDK v3. Thanks @jpatters and @milgner
* Set iam_instance_profile on newly created launch configurations

## 0.6.1

* Provide a way to bypass new AMI/LC generation by setting `set :create_ami, false`.

## 0.6.0

* Breaking change/bug fix: Region-specific settings were not being preserved. A
  new construct is required to set region specific settings. Do this:

```ruby
set 'us-east-1'.to_sym, {
  aws_autoscale_instance_size: 't2.medium',
  aws_lc_name_prefix: 'lc-'
}
```

See the README for more details.

## 0.5.5

* Support setting name prefixes for newly created launch configurations and AMIs
* Use UTC for the timestamps in names

## 0.5.4

* Fix a small bug caused by a typo

## 0.5.3

* Add support to access ID(s) for new AMI(s) created by capistrano-asg

## 0.5.2

* Run after deploy:finishing instead of after deploy
* Return newly created launch configuration in `fetch(:asg_launch_config)`

## 0.5.1

* Fix multi-region AMI and launch config generation

## 0.5.0

* Forked from capistrano-elbas
* renamed capistrano-asg and released as a new gem
* Updated with modern aws sdk
* Added support for multiple regions
