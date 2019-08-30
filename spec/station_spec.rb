require 'station'

describe Station do

  subject { described_class.new("Paddington", 1) }

  it 'responds to zone'do
    expect(subject.zone).to eq(1)
  end
  it 'is created with a name' do
    expect(subject.name).to eq("Paddington")
  end
end
