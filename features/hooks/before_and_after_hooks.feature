Feature: before and after hooks

  As a developer using RSpec
  I want to execute arbitrary code before and after each example
  So that I can control the environment in which it is run

    This is supported by the before and after methods which each take a symbol
    indicating the scope, and a block of code to execute.

    before(:each) blocks are run before each example
    before(:all) blocks are run once before all of the examples in a group
    before(:suite) blocks are run once before the entire suite

    after(:each) blocks are run after each example
    after(:all) blocks are run once after all of the examples in a group
    after(:suite) blocks are run once after the entire suite

    Before and after blocks are called in the following order:
      before suite
      before all
      before each
      after each
      after all
      after suite

    Before and after blocks can be defined in the example groups to which they
    apply or in a configuration. When defined in a configuration, they can be
    applied to all groups or subsets of all groups defined by example group
    types.

  Scenario: define before(:each) block in example group
    Given a file named "before_each_in_example_group_spec.rb" with:
      """
      require "rspec/expectations"

      class Thing
        def widgets
          @widgets ||= []
        end
      end

      describe Thing do
        before(:each) do
          @thing = Thing.new
        end

        describe "initialized in before(:each)" do
          it "has 0 widgets" do
            @thing.should have(0).widgets
          end

          it "can get accept new widgets" do
            @thing.widgets << Object.new
          end

          it "does not share state across examples" do
            @thing.should have(0).widgets
          end
        end
      end
      """
    When I run "rspec before_each_in_example_group_spec.rb"
    Then I should see "3 examples, 0 failures"

  Scenario: define before(:all) block in example group
    Given a file named "before_all_in_example_group_spec.rb" with:
      """
      require "rspec/expectations"

      class Thing
        def widgets
          @widgets ||= []
        end
      end
  
      describe Thing do
        before(:all) do
          @thing = Thing.new
        end
  
        describe "initialized in before(:all)" do
          it "has 0 widgets" do
            @thing.should have(0).widgets
          end
  
          it "can get accept new widgets" do
            @thing.widgets << Object.new
          end
  
          it "shares state across examples" do
            @thing.should have(1).widgets
          end
        end
      end
      """
    When I run "rspec before_all_in_example_group_spec.rb"
    Then I should see "3 examples, 0 failures"

  @wip
  Scenario: define before and after blocks in configuration
    Given a file named "befores_in_configuration_spec.rb" with:
      """
      require "rspec/expectations"

      Rspec.configure do |config|
        config.before(:suite) do
          $before_suite = "before suite"
        end
        config.before(:each) do
          @before_each = "before each"
        end
        config.before(:all) do
          @before_all = "before all"
        end
      end
  
      describe "stuff in before blocks" do
        describe "with :suite" do
          it "should be available in the example" do
            $before_suite.should == "before suite"
          end
        end
        describe "with :all" do
          it "should be available in the example" do
            @before_all.should == "before all"
          end
        end
        describe "with :each" do
          it "should be available in the example" do
            @before_each.should == "before each"
          end
        end
      end
      """
    When I run "rspec befores_in_configuration_spec.rb"
    Then I should see "3 examples, 0 failures"

  @wip
  Scenario: before/after blocks are run in order
    Given a file named "ensure_block_order_spec.rb" with:
      """
      require "rspec/expectations"

      Rspec.configure do |config|
        config.before(:suite) do
          puts "before suite"
        end
        config.after(:suite) do
          puts "after suite"
        end
      end
  
      describe "before and after callbacks" do
        before(:all) do
          puts "before all"
        end
  
        before(:each) do
          puts "before each"
        end
  
        after(:each) do
          puts "after each"
        end
  
        after(:all) do
          puts "after all"
        end
  
        it "gets run in order" do
  
        end
      end
      """
    When I run "rspec ensure_block_order_spec.rb"
    Then I should see /before suite\nbefore all\nbefore each\nafter each\n\.after all\n.*after suite/m
  
