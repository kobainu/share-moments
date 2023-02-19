require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_a) { build(:user) }
  let(:user_b) { build(:user) }

  it 'nameとemail、passwordとpassword_confirmationが存在すれば登録できること' do
    expect(user_a).to be_valid
  end

  it 'nameが未入力では登録できないこと' do
    user_a.name = ""
    user_a.valid?
    expect(user_a.errors[:name]).to include("が入力されていません。")
  end

  it 'nameが11文字以上では登録できないこと' do
    user_a.name = "n" * 11
    user_a.valid?
    expect(user_a.errors[:name]).to include("は10文字以内で入力してください")
  end

  it 'emailが未入力では登録できないこと' do
    user_a.email = ""
    user_a.valid?
    expect(user_a.errors[:email]).to include("が入力されていません。")
  end

  it '重複したemailが存在する場合登録できないこと' do
    user_a.save
    user_b.valid?
    expect(user_b.errors[:email]).to include("は既に使用されています。")
  end

  it 'passwordが未入力では登録できないこと' do
    user_a.password = ""
    user_a.valid?
    expect(user_a.errors[:password]).to include("が入力されていません。")
  end

  it 'passwordが5文字以下では登録できないこと' do
    user_a.password = "p" * 5
    user_a.password_confirmation = "p" * 5
    user_a.valid?
    expect(user_a.errors[:password]).to include("は6文字以上に設定して下さい。")
  end

  it 'passwordとpassword_confirmationが一致しなければ登録できないこと' do
    user_a.password_confirmation = ""
    user_a.valid?
    expect(user_a.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end

  it 'introduction(自己紹介文)は151文字以上では設定できないこと' do
    user_a.introduction = "i" * 151
    user_a.valid?
    expect(user_a.errors[:introduction]).to include("は150文字以内で入力してください")
  end
end
