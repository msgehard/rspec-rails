require 'spec_helper'

describe "Verify required rspec dependencies", :isolated_directory => true do

  it "fails when libraries are not required" do
    File.write "fail_sanity_check", <<-EOF.gsub(/^\s+\|/, '')
      |#!/usr/bin/env ruby
      |RSpec::Support.require_rspec_core "project_initializer"
    EOF
    FileUtils.chmod "+x", "fail_sanity_check"

    expect(`bundle exec fail_sanity_check 2>&1`).
      to match /undefined method `require_rspec_core' for RSpec::Support:Module/
    expect($?.exitstatus).to eq 1
  end

  it "passes when libraries are required" do
    File.write "pass_sanity_check", <<-EOF.gsub(/^\s+\|/, '')
      |#!/usr/bin/env ruby
      |require 'rspec/core'
      |require 'rspec/support'
      |RSpec::Support.require_rspec_core "project_initializer"
    EOF
    FileUtils.chmod "+x", "pass_sanity_check"

    expect(`bundle exec pass_sanity_check 2>&1`).to be_empty
    expect($?.exitstatus).to eq 0
  end

end
