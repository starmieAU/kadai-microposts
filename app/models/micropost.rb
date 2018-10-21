class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255}
  
  has_many :user_microposts
  has_many :favoriters, through: :user_microposts, source: :user

end
