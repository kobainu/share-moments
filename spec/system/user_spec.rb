require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'User CRUD' do 
    describe 'ログイン前' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功すること' do
          visit root_path
          click_link 'アカウント登録'
          fill_in 'user[name]', with: 'test'
          fill_in 'user[email]', with: 'test@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button 'アカウントを登録'
          expect(current_path).to eq posts_path
          expect(page).to have_content 'アカウント登録が完了しました。'
        end

        it 'ユーザーのログインが成功すること' do
          visit root_path
          click_link 'ログイン'
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'ログイン'
          expect(current_path).to eq posts_path
          expect(page).to have_content 'ログインしました。'
        end
      end
    end
  end
end
