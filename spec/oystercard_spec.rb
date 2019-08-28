require "oystercard"

describe Oystercard do
  it { is_expected.to respond_to(:top_up).with(1).argument }
  # it { is_expected.to respond_to(:deduct).with(1).argument }
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
    # it "is reduced after deduct" do
    #   subject.top_up 1
    #   expect{ subject.deduct 1 }.to change { subject.balance }.by -1
    # end

    describe "#in_journey?" do

      it "is false when new oystercard is initalised" do
        expect(subject.in_journey?).to be false
      end

      context 'when card balance is above minimum' do
        it "is in journey when oystercard has been touched in" do
          subject.top_up(1)
          subject.touch_in
          expect(subject).to be_in_journey
        end
      end

      context 'when card balance is above minimum' do
        it "is not in_journey when an oystercard has been touched out" do
          subject.top_up(1)
          subject.touch_in
          subject.touch_out
          expect(subject).not_to be_in_journey
        end
      end
    end

    describe '#touch_in' do
      it "raises an error if the user attempts to touch in when balance is below minimum" do
        expect { subject.touch_in }.to raise_error "Unable to touch-in: Your balance of #{subject.balance} is less than the minimum balance of #{Oystercard::MINIMUM_BALANCE}"
      end
    end
      it "returns the name of the entry station when touched in" do
        subject.top_up(1)
        expect(subject.touch_in("Paddington")).to eq(subject.entry_station)
      end
  end

  describe '#touch_out' do
    context "When the starting balance is above the minimum balance and a user is in-journey" do
      it "reduces the balance by the cost of the journey upon touching-out" do
        subject.top_up(1)
        subject.touch_in
        expect { subject.touch_out }.to change{subject.balance}.by(- Oystercard::FARE)
      end
    end
  end

end
