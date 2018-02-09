# 0.6.1

* Provide a way to bypass new AMI/LC generation by setting `set :create_ami, false`.
# 0.6.0

* Breaking change/bug fix: Region-specific settings were not being preserved. A
  new construct is required to set region specific settings. Do this:

```ruby
set 'us-east-1'.to_sym, {
  aws_autoscale_instance_size: 't2.medium',
  aws_lc_name_prefix: 'lc-'
}
```

See the README for more details.

# 0.5.5

* Support setting name prefixes for newly created launch configurations and AMIs
* Use UTC for the timestamps in names

# 0.5.4

* Fix a small bug caused by a typo

# 0.5.3

* Add support to access ID(s) for new AMI(s) created by capistrano-asg

# 0.5.2

* Run after deploy:finishing instead of after deploy
* Return newly created launch configuration in `fetch(:asg_launch_config)`

# 0.5.1

* Fix multi-region AMI and launch config generation

# 0.5.0

* Forked from capistrano-elbas
* renamed capistrano-asg and released as a new gem
* Updated with modern aws sdk
* Added support for multiple regions
