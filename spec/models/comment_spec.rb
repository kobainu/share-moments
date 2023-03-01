require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { create(:post, photo: photo) }
  let(:comment) { create(:comment, user_id: user.id, post_id: post.id) }

  it "空欄ではなく、150文字以内であればコメントできること" do
    comment.comment = 'c' * 150
    expect(comment).to be_valid
  end

  it "未入力ではコメントできないこと" do
    comment.comment = ''
    comment.valid?
    expect(comment.errors.full_messages).to include("コメントを入力してください")
  end

  it "151文字以上ではコメントできないこと" do
    comment.comment = 'c' * 151
    comment.valid?
    expect(comment.errors.full_messages).to include("コメントは150文字以内で入力してください")
  end
end
