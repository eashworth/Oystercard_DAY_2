class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  FARE = 1

  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    over_limit?(amount)
    @balance += amount
  end

  def in_journey?
    @in_use
  end

  def touch_in(entry_station)
    raise "Unable to touch-in: Your balance of #{@balance} is less than the minimum balance of #{MINIMUM_BALANCE}" if @balance < MINIMUM_BALANCE
    @in_use = true
    @entry_station = entry_station
  end

  def touch_out
    @in_use = false
    deduct(FARE)
  end

  private

  def deduct(fare)
    @balance -= fare
  end

  def over_limit?(amount)
    raise "You have reached your top-up limit of #{MAXIMUM_BALANCE}." if @balance + amount > MAXIMUM_BALANCE
  end

end
