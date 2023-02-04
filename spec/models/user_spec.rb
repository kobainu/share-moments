require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前、メール、パスワードがある場合、有効である' do
    user = User.new(
      name: 'test_user',
      email: 'test@example.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  it '名前がない場合、無効である' do
    user = User.new(
      name: nil,
      email: 'test@example.com',
      password: 'password'
    )
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'メールアドレスがない場合、無効である' do
    user = User.new(
      name: 'test_user',
      email: nil,
      password: 'password'
    )
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it '重複したメールアドレスの場合、無効である' do
    User.create(
      name: 'test_user',
      email: 'test@example.com',
      password: 'password'
    )
    other_user = User.new(
      name: 'other_user',
      email: 'test@example.com',
      password: 'password'
    )
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end

  it 'パスワードがない場合、無効である' do
    user = User.new(
      name: 'test_user',
      email: 'test@example.com',
      password: nil
    )
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end
end
