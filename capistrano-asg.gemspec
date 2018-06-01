# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/asg/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-asg'
  spec.version       = Capistrano::Asg::VERSION
  spec.authors       = ['Logan Serman', 'Jeff Fraser', 'Michael Martell']
  spec.email         = ['logan.serman@metova.com', 'jeff.fraser@veracross.com', 'michael.martell@veracross.com']
  spec.summary       = 'Capistrano plugin for deploying to AWS AutoScale Groups.'
  spec.description   = "#{spec.summary} Deploys to all instances in a group, creates a fresh AMI post-deploy, and attaches the AMI to your AutoScale Group."
  spec.homepage      = 'http://github.com/sixfeetover/capistrano-asg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'byebug'

  spec.add_dependency 'aws-sdk-ec2', '~> 1'
  spec.add_dependency 'aws-sdk-autoscaling', '~> 1'
  spec.add_dependency 'capistrano', '> 3.0.0'
  spec.add_dependency 'activesupport', '>= 4.0.0'
end
