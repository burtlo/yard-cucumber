#
# @see https://github.com/burtlo/yard-cucumber/issues/18
# 
CustomerUsageBehavior = Struct.new(:weight, :days, :time, :location, :other_party, :usage_type, :direction, :quantity)


class CustomerProfile
  def generate_winner(max=@total_weight)
     # blah
  end
end