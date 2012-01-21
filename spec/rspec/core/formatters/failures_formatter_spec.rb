require 'spec_helper'
require 'rspec/core/formatters/failures_formatter'

describe RSpec::Core::Formatters::FailuresFormatter do
  before do
    group = RSpec::Core::ExampleGroup.describe("test")
    @example1 = group.example("example 1"){}
    @example2 = group.example("example 2"){}
    @example3 = group.example("example 3"){}

    @output = StringIO.new
    @formatter = RSpec::Core::Formatters::FailuresFormatter.new(@output)
  end

  it "outputs the present working directory" do
    @formatter.start(0)
    @formatter.start_dump
    data = YAML.load(@output.string)
    data[:pwd].should == Dir.pwd
  end

  it "outputs the version as 1" do
    @formatter.start(0)
    @formatter.start_dump
    data = YAML.load(@output.string)
    data[:version].should == 1
  end

  it "outputs the failing examples" do
    @formatter.start(3)
    @formatter.example_failed(@example1)
    @formatter.example_passed(@example2)
    @formatter.example_failed(@example3)
    @formatter.start_dump
    data = YAML.load(@output.string)
    data[:examples].should == ['test example 1', 'test example 3']
  end

  describe "#default_output_path" do
    it "returns the configured failure file" do
      configuration = RSpec::Core::Configuration.new
      configuration.failure_file = 'path'
      path = RSpec::Core::Formatters::FailuresFormatter.default_output_path(configuration)
      path.should == 'path'
    end
  end
end
