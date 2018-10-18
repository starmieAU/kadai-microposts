class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :follow_relations
  has_many :followings, through: :follow_relations, source: :follow
  has_many :following_relations, class_name: 'FollowRelation', foreign_key: 'follow_id'
  has_many :followers, through: :following_relations, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.follow_relations.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    follow_relation = self.follow_relations.find_by(follow_id: other_user.id)
    follow_relation.destroy if follow_relation
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
end
