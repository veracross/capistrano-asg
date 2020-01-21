# frozen_string_literal: true

class DoxStyleGenerator < Rails::Generators::Base
  RUBOCOP_CONFIG_FILE = ".rubocop.yml"

  source_root(
    File.expand_path("#{Dir.pwd}/lib/generators/dox_style/templates", __dir__)
  )

  def prepend_to_rubocop
    in_root do
      if File.exist?(RUBOCOP_CONFIG_FILE)
        template = File.read("#{source_paths.first}/.rubocop.yml")
        prepend_to_file ".rubocop.yml", template
      else
        copy_file ".rubocop.yml", RUBOCOP_CONFIG_FILE
      end
    end
  end
end
