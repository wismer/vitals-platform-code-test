class AwardEval
  def initialize(expires_in, quality, props={})
    @expires_in   = expires_in
    @quality      = quality
    @expired_rate = props[:expired_rate]
    @growth_rate  = props[:growth_rate]
    @rates        = props[:rates]

    yield self
  end

  def multiple_rate_award?
    @rates.is_a?(Hash)
  end

  def rate
    @rates.keys.find { |rate| rate === @expires_in }
  end

  def about_to_expire_award
    @quality += multiple_rate_award? ? (@rates[rate] || -@quality) : @expired_rate
  end

  def unexpired_award
    @quality += multiple_rate_award? ? @rates[rate] : @growth_rate
  end

  def expired_award
    @quality += (@expired_rate || -@quality)
  end

  def revalue_award
    case @expires_in <=> 0
    when  1 then unexpired_award
    when -1 then expired_award
    when  0 then about_to_expire_award
    end

    if @quality > 50
      @quality = 50
    elsif @quality < 0
      @quality = 0
    end

    return @quality, @expires_in - 1
  end
end
