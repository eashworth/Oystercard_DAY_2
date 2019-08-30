require "oystercard"

describe Oystercard do
  #let(:balance){ 1 } #change to set let for balance - research correct syntax/scope.
  #subject { decribed_class.new(balance: 1) #???} Fails because .new does not expect arguments.
  let(:entry_station){ double :entry_station}
  let(:exit_station){ double :exit_station }
  it { is_expected.to respond_to(:top_up).with(1).argument }
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
  end

  describe '#journeys' do
    let(:journey){ {entry: entry_station, exit: exit_station} }

    it 'has an empty list of journeys when created' do
      expect(subject.journeys). to eq([])
    end
    it 'stores one journey as a pair on entry and exit stations' do
      subject.top_up(1)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to eq([{entry: entry_station, exit: exit_station}])
    end

    it 'stores a journey' do
      subject.top_up(1)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end
  end

  describe "#in_journey?" do

    it "is false when new oystercard is initalised" do
      expect(subject.in_journey?).to be false
    end

    context 'when card balance is above minimum' do
      it "is in journey when oystercard has been touched in" do
        subject.top_up(1)
        subject.touch_in(entry_station)
        expect(subject).to be_in_journey
      end
    end

    context 'when card balance is above minimum' do
      it "is not in_journey when an oystercard has been touched out" do
        subject.top_up(1)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject).not_to be_in_journey
      end
    end
  end

  describe '#touch_in' do
    it "raises an error if the user attempts to touch in when balance is below minimum" do
      expect { subject.touch_in(entry_station) }.to raise_error "Unable to touch-in: Your balance of #{subject.balance} is less than the minimum balance of #{Oystercard::MINIMUM_BALANCE}"
    end
  end

  it 'stores the entry station' do
    subject.top_up(1)
    subject.touch_in(entry_station)
    expect(subject.entry_station).to eq entry_station
  end

  describe '#touch_out' do
    context "When the starting balance is above the minimum balance and a user is in-journey" do
      it "reduces the balance by the cost of the journey upon touching-out" do
        subject.top_up(1)
        subject.touch_in(entry_station)
        expect { subject.touch_out(exit_station) }.to change{subject.balance}.by(- Oystercard::FARE)
      end
      it 'sets the entry station by setting it to nil' do
        subject.top_up(1)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station)
        expect(subject.entry_station). to eq(nil)
      end
    end
  end

end
