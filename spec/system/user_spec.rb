require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }

  describe 'User CRUD' do
    describe 'ログイン前' do
      describe 'アカウント登録' do
        context 'フォームの入力値が正常' do
          it 'アカウント登録が成功すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'n' * 10
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'p' * 6
            fill_in 'user[password_confirmation]', with: 'p' * 6
            click_button 'アカウントを登録'
            expect(current_path).to eq posts_path
            expect(page).to have_content 'アカウント登録が完了しました。'
          end
        end

        context 'ニックネームが未記入' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: ''
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: 'password'
            click_button 'アカウントを登録'
            expect(page).to have_content 'ニックネームを入力して下さい。'
          end
        end

        context 'ニックネームが11文字以上' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'n' * 11
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: 'password'
            click_button 'アカウントを登録'
            expect(page).to have_content 'ニックネームは10文字以内で入力して下さい。'
          end
        end

        context 'メールアドレスが未記入' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'test'
            fill_in 'user[email]', with: ''
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: 'password'
            click_button 'アカウントを登録'
            expect(page).to have_content 'メールアドレスを入力して下さい。'
          end
        end

        context 'メールアドレスが登録済みである' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'test'
            fill_in 'user[email]', with: user.email
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: 'password'
            click_button 'アカウントを登録'
            expect(page).to have_content 'メールアドレスが既に使用されています。'
          end
        end

        context 'パスワードが未記入' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'test'
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: ''
            fill_in 'user[password_confirmation]', with: 'password'
            click_button 'アカウントを登録'
            expect(page).to have_content 'パスワードを設定して下さい。'
          end
        end

        context 'パスワードが5文字以下' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'test'
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'p' * 5
            fill_in 'user[password_confirmation]', with: 'p' * 5
            click_button 'アカウントを登録'
            expect(page).to have_content 'パスワードは6文字以上で設定して下さい。'
          end
        end

        context 'パスワードと確認用パスワードが不一致' do
          it 'アカウント登録が失敗すること' do
            visit root_path
            click_link 'アカウント登録'
            fill_in 'user[name]', with: 'test'
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: ''
            click_button 'アカウントを登録'
            expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
          end
        end
      end

      describe 'ログイン' do
        context 'フォームの入力値が正常' do
          it 'ログインが成功すること' do
            visit root_path
            click_link 'ログイン'
            fill_in 'user[email]', with: user.email
            fill_in 'user[password]', with: user.password
            click_button 'ログイン'
            expect(current_path).to eq posts_path
            expect(page).to have_content 'ログインしました。'
          end
        end

        context 'メールアドレスが不一致' do
          it 'ログインが失敗すること' do
            visit root_path
            click_link 'ログイン'
            fill_in 'user[email]', with: user.email
            fill_in 'user[password]', with: ''
            click_button 'ログイン'
            expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
          end
        end

        context 'パスワードが不一致' do
          it 'ログインが失敗すること' do
            visit root_path
            click_link 'ログイン'
            fill_in 'user[email]', with: user.email
            fill_in 'user[password]', with: ''
            click_button 'ログイン'
            expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
          end
        end

        context 'ゲストログイン' do
          it 'ゲストログインが成功すること' do
            visit root_path
            click_link 'ゲストログイン'
            expect(current_path).to eq posts_path
            expect(page).to have_content 'ゲストユーザーとしてログインしました。'
          end
        end
      end
    end

    describe 'ログイン後' do
      before { login(user) }

      describe 'アカウント編集' do
        context 'フォームの入力値が正常' do
          it 'アカウント情報の編集が成功すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: 'test_edit@example.com'
            fill_in 'user[password]', with: 'password_edit'
            fill_in 'user[password_confirmation]', with: 'password_edit'
            fill_in 'user[current_password]', with: user.password
            click_button 'アカウント情報を変更'
            expect(current_path).to eq posts_path
            expect(page).to have_content 'アカウント情報を変更しました。'
          end
        end

        context 'メールアドレスが未記入' do
          it 'アカウント情報の編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: ''
            fill_in 'user[password]', with: 'password_edit'
            fill_in 'user[password_confirmation]', with: 'password_edit'
            fill_in 'user[current_password]', with: user.password
            click_button 'アカウント情報を変更'
            expect(page).to have_content 'メールアドレスを入力して下さい。'
          end
        end

        context '現在のパスワードが未記入' do
          it 'アカウント情報の編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: 'test_edit@example.com'
            fill_in 'user[password]', with: 'password_edit'
            fill_in 'user[password_confirmation]', with: 'password_edit'
            fill_in 'user[current_password]', with: ''
            click_button 'アカウント情報を変更'
            expect(page).to have_content '現在のパスワードを入力してください'
          end
        end

        context '現在のパスワードが不一致' do
          it 'アカウント情報の編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: 'test_edit@example.com'
            fill_in 'user[password]', with: 'password_edit'
            fill_in 'user[password_confirmation]', with: 'password_edit'
            fill_in 'user[current_password]', with: 'error_pass'
            click_button 'アカウント情報を変更'
            expect(page).to have_content '現在のパスワードは不正な値です'
          end
        end

        context '新しいパスワードが5文字以下' do
          it 'アカウント登録が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'p' * 5
            fill_in 'user[password_confirmation]', with: 'p' * 5
            fill_in 'user[current_password]', with: user.password
            click_button 'アカウント情報を変更'
            expect(page).to have_content 'パスワードは6文字以上で設定して下さい。'
          end
        end

        context '新しいパスワードと確認用パスワードが不一致' do
          it 'アカウント登録が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            fill_in 'user[email]', with: 'test@example.com'
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: ''
            fill_in 'user[current_password]', with: user.password
            click_button 'アカウント情報を変更'
            expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
          end
        end
      end

      describe 'プロフィール編集' do
        context 'フォームの入力値が正常' do
          it 'プロフィール編集が成功すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            attach_file 'user[image]', Rails.root.join('spec/fixture/image.jpg')
            fill_in 'user[name]', with: 'n' * 10
            fill_in 'user[introduction]', with: 'i' * 150
            click_button 'プロフィールを更新'
            expect(current_path).to eq user_path(user.id)
            expect(page).to have_content 'プロフィールを更新しました。'
          end
        end

        context 'ニックネームが未記入' do
          it 'プロフィール編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            attach_file 'user[image]', Rails.root.join('spec/fixture/image.jpg')
            fill_in 'user[name]', with: ''
            click_button 'プロフィールを更新'
            expect(page).to have_content 'ニックネームを入力して下さい。'
          end
        end

        context 'ニックネームが11文字以上' do
          it 'プロフィール編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            attach_file 'user[image]', Rails.root.join('spec/fixture/image.jpg')
            fill_in 'user[name]', with: 'n' * 11
            click_button 'プロフィールを更新'
            expect(page).to have_content 'ニックネームは10文字以内で入力して下さい。'
          end
        end

        context '自己紹介が151文字以上' do
          it 'プロフィール編集が失敗すること' do
            visit posts_path
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            attach_file 'user[image]', Rails.root.join('spec/fixture/image.jpg')
            fill_in 'user[introduction]', with: 'i' * 151
            click_button 'プロフィールを更新'
            expect(page).to have_content '自己紹介は150文字以内で入力して下さい。'
          end
        end
      end
    end
  end

  describe 'view' do
    describe '画面遷移' do
      describe 'TOPページからの遷移' do
        before  { visit root_path }

        context 'アカウント登録ページへの遷移' do
          it '「アカウント登録」をクリック' do
            click_link 'アカウント登録'
            expect(current_path).to eq new_user_registration_path
            expect(page).to have_content 'アカウント登録'
          end
        end

        context 'ログインページへの遷移' do
          it '「ログイン」をクリック' do
            click_link 'ログイン'
            expect(current_path).to eq new_user_session_path
            expect(page).to have_content 'ログイン'
          end
        end
      end

      describe 'アカウント登録ページからの遷移' do
        before  { visit new_user_registration_path }

        context 'ログインページへの遷移' do
          it '「ログイン画面へ」をクリック' do
            click_link 'ログイン画面へ'
            expect(current_path).to eq new_user_session_path
            expect(page).to have_content 'ログイン'
          end
        end
      end

      describe 'ログインページからの遷移' do
        before  { visit new_user_session_path }

        context 'アカウント登録画面への遷移' do
          it '「アカウント登録画面へ」をクリック' do
            click_link 'アカウント登録画面へ'
            expect(current_path).to eq new_user_registration_path
            expect(page).to have_content 'アカウント登録'
          end
        end

        context 'パスワード再設定ページへの遷移' do
          it '「パスワードをお忘れの場合はこちら」をクリック' do
            click_link 'パスワードをお忘れの場合はこちら'
            expect(current_path).to eq new_user_password_path
            expect(page).to have_content 'パスワード再設定のメールを送信'
          end
        end
      end

      describe 'サイドバーメニューからの遷移' do
        before do
          login(user)
          visit posts_path
        end

        context 'アカウント編集画面への遷移' do
          it '「アカウント編集」をクリック' do
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            expect(current_path).to eq edit_user_registration_path
            expect(page).to have_content 'アカウント編集'
          end
        end

        context 'プロフィール編集画面への遷移' do
          it '「プロフィール編集」をクリック' do
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            expect(current_path).to eq profile_users_path
            expect(page).to have_content 'プロフィール編集'
          end
        end

        context 'ログアウト後にTOPページへの遷移' do
          it '「ログアウト」をクリック' do
            within ".ly_sidebar" do
              click_link 'ログアウト'
            end
            expect(current_path).to eq root_path
            expect(page).to have_content 'ログアウトしました。'
          end
        end
      end

      describe 'ヘッダーメニューからの遷移' do
        before do
          login(user)
          visit posts_path
        end

        context 'ログアウト後にTOPページへの遷移' do
          it '「ログアウト」をクリック' do
            within ".ly_header" do
              click_link 'ログアウト'
            end
            expect(current_path).to eq root_path
            expect(page).to have_content 'ログアウトしました。'
          end
        end
      end
    end
  end
end
