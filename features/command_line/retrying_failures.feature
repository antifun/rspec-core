Feature: Retrying Failures

  You can rery some or all failing examples.

  First, you need to record the failing examples by enabling the
  failures formatter. You can do this as follows:

    $ rspec --format failures   # record the failures

  Then to retry the failing examples, do one of these:

    $ rspec --retry             # retry the failures
    $ rspec --retry=1-3,5       # retry just these failures

  You can specify the file to record the failures in with --failure-file:

    $ rspec --failure-file /path/to/file --format failures
    $ rspec --failure-file --retry

  Of course the failure file may be specified in an options file or as
  a configuration setting instead of on the command line.

  Scenario: running specs with the failure formatter enabled
    Given a file named "example_spec.rb" with:
      """
      describe "test" do
        it "fail 1" do
          true.should == false
        end
      end
      """
    When I run `rspec example_spec.rb --format failures`
    Then a file named ".rspec_failures.yml" should exist

  Scenario: retrying failures when there was at least one failure
    Given a file named "example_spec.rb" with:
      """
      describe "test" do
        it "pass 1" do
          true.should == true
        end

        it "fail 1" do
          true.should == false
        end

        it "pending"
      end
      """
    And I run `rspec example_spec.rb --format failures`
    And I run `rspec example_spec.rb --retry`
    Then the output should contain "1 example, 1 failure"

  Scenario: retrying failures when there are none
    Given a file named "example_spec.rb" with:
      """
      describe "test" do
        it "pass 1" do
          true.should == true
        end
      end
      """
    And I run `rspec example_spec.rb --format failures`
    And I run `rspec example_spec.rb --retry`
    Then the output should contain "0 examples, 0 failures"
