require 'rspec/core/formatters/base_formatter'
require 'yaml'

module RSpec
  module Core
    module Formatters
      class FailuresFormatter < BaseFormatter
        def self.default_output_path(configuration)
          @default_output_path ||= configuration.failure_file
        end

        def initialize(output)
          super
          @pwd = Dir.pwd
        end

        def start_dump
          data = {
            :version => 1,
            :pwd => @pwd,
            :examples => @failed_examples.map { |e| e.full_description }
          }
          YAML.dump(data, output)
        end
      end
    end
  end
end
