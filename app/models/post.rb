class Post < ApplicationRecord
  validates :photo, presence: { message: 'を選択して下さい' }
  validates :title, presence: true, length: { maximum: 20 }
  validates :description, length: { maximum: 150 }

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  mount_uploader :photo, ImageUploader

  def save_tag(sent_tags)
    # createアクションにて保存した@postに紐付いているタグが存在する場合、「タグの名前を配列として」全て取得する
    current_tags = tags.pluck(:tag_name) unless tags.nil?
    # 取得した@postに存在するタグから、送信されてきたタグを除いたタグをold_tagsとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから、現在存在するタグを除いたタグをnew_tagsとする
    new_tags = sent_tags - current_tags
    # 古いタグを削除
    old_tags.each do |old|
      tags.delete Tag.find_by(tag_name: old)
    end
    # 新しいタグをDBに保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      tags << new_post_tag
    end
  end
end
