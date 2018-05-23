# frozen_string_literal: true

module Capistrano
  module Asg
    module Aws
      module Credentials
        extend ActiveSupport::Concern
        include Capistrano::DSL

        def credentials
          access_key_id = fetch(:aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])
          secret_access_key = fetch(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
          ::Aws::Credentials.new(access_key_id, secret_access_key)
        end
      end
    end
  end
end
