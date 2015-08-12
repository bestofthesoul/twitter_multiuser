class Tweet < ActiveRecord::Base
  belongs_to :twitter_user

  
  # def still_valid?
  #   created_at = self.created_at
  #   now = Time.now
  #   if now - created_at  > 20
  #     false
  #   else
  #     true
  #   end
  # end
end
