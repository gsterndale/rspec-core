require 'spec_helper'

describe Rspec::Core::Example, :parent_metadata => 'sample' do

  before do
    example_group = stub('example_group', 
      :metadata => Rspec::Core::Metadata.new.process(
        'group description',
        :caller => ['foo_spec.rb:37']
      )
    ).as_null_object 
    @example = Rspec::Core::Example.new(example_group, 'example description', {}, (lambda {}))
  end

  describe "attr readers" do
    it "should have one for the parent example group" do
      @example.should respond_to(:example_group)
    end

    it "should have one for it's description" do
      @example.should respond_to(:description)
    end

    it "should have one for it's metadata" do
      @example.should respond_to(:metadata)
    end

    it "should have one for it's block" do
      @example.should respond_to(:example_block)
    end

    it "should have one for its subject modifier" do
      @example.should respond_to(:subject_modifier)
    end

    it "should have one for its state" do
      @example.should respond_to(:state)
    end
  end

  describe '#inspect' do
    it "should return 'group description - description'" do
      @example.inspect.should == 'group description example description'
    end
  end

  describe '#to_s' do
    it "should return #inspect" do
      @example.to_s.should == @example.inspect
    end
  end

  describe '#described_class' do
    it "returns the class (if any) of the outermost example group" do
      described_class.should == Rspec::Core::Example
    end
  end

  describe "accessing metadata within a running example" do
    it "should have a reference to itself when running" do
      running_example.description.should == "should have a reference to itself when running"
    end

    it "should be able to access the example group's top level metadata as if it were its own" do
      running_example.example_group.metadata.should include(:parent_metadata => 'sample')
      running_example.metadata.should include(:parent_metadata => 'sample')
    end
  end

  describe "#run" do
    pending "should run after(:each) when the example fails"

    pending "should run after(:each) when the example raises an Exception" 
  end

  describe "#state" do
    before do
      running_example.state.should == :before
    end
    it "should have block state while running actual example block" do
      running_example.state.should == :block
    end
    after do
      running_example.state.should == :after
    end
  end
end
