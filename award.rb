class Award
  attr_reader :name
  attr_accessor :expires_in, :quality

  def initialize(name, expires_in, quality)
    @name, @expires_in, @quality = name, expires_in, quality
  end

  def update
    case @name
    when "Blue First"   then apply(:blue_first)
    when "Blue Compare" then apply(:blue_compare)
    when "NORMAL ITEM"  then apply(:generic)
    when "Blue Star"    then apply(:blue_star)
    else
      apply(:distinction_plus)
    end
  end

  def apply(key)
    award = properties[key]

    AwardEval.new(@expires_in, @quality, award) do |prop|
      @quality, @expires_in = prop.revalue_award if @quality != 80
    end
  end

  def properties
    @properties ||= {
      blue_compare: {
        rates: {
          (1..5)   => 3,
          (6..10)  => 2,
          (11..50) => 1
        }
      },

      blue_star: {
        expired_rate: -4,
        rates: {
          (0)     => -4,
          (1..50) => -2
        }
      },

      generic: {
        expired_rate: -2,
        rates: {
          (0) => -2,
          (1..50) => -1
        }
      },

      blue_first: {
        expired_rate: 2,
        growth_rate: 1
      },

      distinction_plus: {
        expired_rate: 0,
        growth_rate: 0
      }
    }
  end
end
