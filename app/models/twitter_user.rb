class TwitterUser < ActiveRecord::Base
  has_many :tweets



# WHEN THERE IS ONLY ONE USER
  # def fetch_tweets(username)
  #   @twitter_user = TwitterUser.find_or_create_by(username: username)
  #   @tweets = @twitter_user.tweets
  #   if !@tweets.empty?
  #     @twitter_user.tweets.destroy_all
  #   end

  #   @tweets = $client.user_timeline(username, count: 10)
  #   @tweets.each do |tweet|
  #   @twitter_user.tweets.create(text: tweet.text)
  #   end
  # end

# WHEN THERE R MULTIPLE USERS...
  def fetch_tweets
  	unless self.tweets.empty?
  		self.tweets.destroy_all
  	end	
    	client = generate(self)
      # byebug
      # client.user_timeline(self.username, count(3)).each do |tweet|  --> count doesnt work here
      client.user_timeline(self.username).take(3).each do |tweet|
    	self.tweets.create(tweet: tweet.text)
  	end
  end



  def post_tweet(a)
    client = generate(self)
    client.update(a)    
  end


  def tweet_still_valid?
  	if self.tweets.empty?
  		false
  	else
      created_at = self.tweets.first.created_at  # RMBR TO PUT .FIRST (-->LATEST POST)
      now = Time.now
      if now - created_at  > 200
        false
      else
        true
      end
	  end	
  end


  private
    def generate(user)
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = API_KEYS["twitter_consumer_key_id"]
        config.consumer_secret     = API_KEYS["twitter_consumer_secret_key_id"]
        config.access_token        = user.access_token
        config.access_token_secret = user.access_token_secret
      end
    end
  
end




  # def fetch_other_tweets(username)
  #   @twitter_user = TwitterUser.find_or_create_by(username: username)
  #   @tweets = @twitter_user.tweets

  #   if !@tweets.empty?
  #     @twitter_user.tweets.destroy_all
  #   end
  #   client = generate(self)
  #   @tweets = client.user_timeline(username, count: 10)
  #   @tweets.each do |tweet|
  #   @twitter_user.tweets.create(tweet: tweet.tweet)
  #   end
  # end

