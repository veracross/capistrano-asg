# frozen_string_literal: true

describe Capistrano::Asg::AMI do
  describe "#tag" do
    subject { Capistrano::Asg::AMI.new }

    it "retries the tag 3 times" do
      skip
      expect(subject).to(receive(:aws_counterpart).exactly(3).times { raise RuntimeError })
      subject.tag "Test" => true
    end
  end
end
