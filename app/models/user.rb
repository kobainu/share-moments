class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  has_many :posts
  has_many :favorites

  mount_uploader :image, ImageUploader

  validates :name, presence: true

  def favorite_find(post_id)
    favorites.where(post_id: post_id).exists?
  end
end
