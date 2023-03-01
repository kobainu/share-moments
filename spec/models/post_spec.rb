require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { build(:post) }

  it "タイトルと写真が入力されていれば投稿できること" do
    post.photo = photo
    expect(post).to be_valid
  end
  
  it "タイトルが未入力の場合投稿できないこと" do
    post.title = ''
    post.valid?
    expect(post.errors.full_messages).to include("タイトルを入力してください")
  end
  
  it "写真が選択されていなければ投稿できないこと" do
    post.valid?
    expect(post.errors.full_messages).to include("投稿する写真を入力してください")
  end
end
