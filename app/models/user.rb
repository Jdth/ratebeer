class User < ActiveRecord::Base
	include RatingAverage

	has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	has_secure_password

	validates :username, uniqueness: true, length: { in: 3..15 }
	validates :password, length: {in: 4..30}
	validates :password, format: { with: /[A-Z]/,
    message: "must include at least one letter in uppercase" }
	validates :password, format: { with: /[0-9]/,
		message: "must include at least one number" }

end
