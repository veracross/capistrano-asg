# frozen_string_literal: true

module Capistrano
  module Asg
    module Aws
      module Region
        extend ActiveSupport::Concern
        include Capistrano::DSL

        def region
          fetch(:aws_region, ENV["AWS_REGION"])
        end
      end
    end
  end
end
