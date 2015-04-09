require 'award'
require 'award_eval'

def update_quality(awards)
  awards.each(&:update)
end
