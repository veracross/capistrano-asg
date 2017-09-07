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
