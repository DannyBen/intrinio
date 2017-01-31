require 'spec_helper'

describe 'bin/intrinio' do
  it "shows usage patterns" do
    expect(`bin/intrinio`).to match /Usage:/
  end

  it "shows help" do
    expect(`bin/intrinio --help`).to match /Commands:/
  end

  it "shows version" do
    expect(`bin/intrinio --version`).to eq "#{VERSION}\n"
  end
end
