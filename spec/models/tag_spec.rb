require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { build(:tag) }

  it '10文字以内であれば登録できること' do
    expect(tag).to be_valid
  end

  it '11文字以上では登録できないこと' do
    tag.tag_name = 't' * 11
    tag.valid?
    expect(tag.errors.full_messages).to include("タグ名は10文字以内で入力してください")
  end
end
