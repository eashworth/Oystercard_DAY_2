require "oystercard"

describe Oystercard do
  it { is_expected.to respond_to(:top_up).with(1).argument }
  it { is_expected.to respond_to(:deduct).with(1).argument }
  it { is_expected.to respond_to(:in_journey?) }

  describe "#balance" do
    it "has a default balance of 0 when intiliazed" do
      expect(subject.balance).to eq(0)
    end
    it "is incremented after top-up" do
      expect{ subject.top_up 1 }.to change { subject.balance }.by 1
    end
    it "raises an error if user attempts to top up the balance above max balance limit" do
      subject.top_up Oystercard::MAXIMUM_BALANCE
      expect { subject.top_up 1 }.to raise_error "You have reached your top-up limit of #{Oystercard::MAXIMUM_BALANCE}."
    end
    it "is reduced after deduct" do
      subject.top_up 1
      expect{ subject.deduct 1 }.to change { subject.balance }.by -1
    end

describe "#in_journey?" do

    it "is false when new oystercard is initalised" do
      expect(subject.in_journey?).to be false
    end

    it "is true when oystercard has been touched in" do
      subject.touch_in
      expect(subject).to be_in_journey
    end

    it "is false when an oystercard has been touched out" do
      subject.touch_in
      subject.touch_out
      expect(subject).not_to be_in_journey
    end
    end
  end
end
