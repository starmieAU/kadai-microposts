class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  
  has_many :follow_relations, dependent: :destroy
  has_many :followings, through: :follow_relations, source: :follow
  has_many :followers_relations, class_name: 'FollowRelation', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :followers_relations, source: :user

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
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  has_many :user_microposts, dependent: :destroy
  has_many :favoritings, through: :user_microposts, source: :micropost
  
  def favo(micropost)
    self.user_microposts.find_or_create_by(micropost_id: micropost.id)
  end

  def unfavo(micropost)
    user_micropost = self.user_microposts.find_by(micropost_id: micropost.id)
    user_micropost.destroy if user_micropost
  end

  def favo?(micropost)
    self.favoritings.include?(micropost)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id]).or(Micropost.where(id: self.favoriting_ids))
  end
  
end
