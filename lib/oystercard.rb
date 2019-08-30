class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  FARE = 1

  attr_reader :balance, :entry_station, :journeys

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(amount)
    over_limit?(amount)
    @balance += amount
  end

  def in_journey?
    !@entry_station.nil?
  end

  def touch_in(entry_station)
    raise "Unable to touch-in: Your balance of #{@balance} is less than the minimum balance of #{MINIMUM_BALANCE}" if @balance < MINIMUM_BALANCE
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(FARE)
    @exit_station = exit_station
    @journeys.push({entry: entry_station, exit: exit_station})
    @entry_station = nil
  end

  private

  def deduct(fare)
    @balance -= fare
  end

  def over_limit?(amount)
    raise "You have reached your top-up limit of #{MAXIMUM_BALANCE}." if @balance + amount > MAXIMUM_BALANCE
  end

end
