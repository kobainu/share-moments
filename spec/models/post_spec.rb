require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { build(:post, photo: photo) }

  it "タイトルと写真が入力されていれば投稿できること" do
    expect(post).to be_valid
  end
  
  it "タイトルが未入力の場合投稿できないこと" do
    post.title = ''
    post.valid?
    expect(post.errors.full_messages).to include("タイトルを入力してください")
  end

  it "タイトルが20文字以内であれば投稿できること" do
    post.title = 't' * 20
    expect(post).to be_valid
  end

  it "タイトルが21文字以上では投稿できないこと" do
    post.title = 't' * 21
    post.valid?
    expect(post.errors.full_messages).to include("タイトルは20文字以内で入力してください")
  end
  
  it "写真が選択されていなければ投稿できないこと" do
    post.photo = nil
    post.valid?
    expect(post.errors.full_messages).to include("投稿する写真を選択して下さい")
  end

  it "投稿紹介が150文字以内であれば投稿できること" do
    post.description = 't' * 150
    expect(post).to be_valid
  end

  it "投稿紹介が151文字以上では投稿できないこと" do
    post.description = 't' * 151
    post.valid?
    expect(post.errors.full_messages).to include("投稿紹介は150文字以内で入力してください")
  end
end
