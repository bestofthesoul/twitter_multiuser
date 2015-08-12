class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
	# t.integer  :uid
	t.string :username
	t.string :access_token
	t.string :access_token_secret
	t.timestamps null: false
    end
  end
end
