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

  context "with bad response" do
    it "exits with honor" do
      command = 'bin/intrinio get --csv historical_data identifier:asd 2>&1'
      expect(`#{command}`).to eq "Intrinio::BadResponse - API said '400 Bad Request'\n"
    end
  end

  context "with incompatible response" do
    it "exits with honor" do
      command = 'bin/intrinio get --csv indices identifier:\$FF 2>&1'
      expect(`#{command}`).to eq "Intrinio::IncompatibleResponse - There is no data attribute in the response\n"
    end
  end
end
