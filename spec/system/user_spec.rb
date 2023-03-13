require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, name: 'other_user') }
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { create(:post, user_id: user.id, photo: photo) }
  let(:other_post) { create(:post, user_id: other_user.id, photo: photo) }

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
    context 'ログイン前' do
      describe 'TOPページ' do
        before { visit root_path }

        it '「アカウント登録」リンクをクリックするとアカウント登録ページへの遷移すること' do
          click_link 'アカウント登録'
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_content 'アカウント登録'
        end

        it '「ログイン」をクリックするとログインページへ遷移すること' do
          click_link 'ログイン'
          expect(current_path).to eq new_user_session_path
          expect(page).to have_content 'ログイン'
        end
      end

      describe 'アカウント登録ページ' do
        before { visit new_user_registration_path }

        it '「ログイン画面へ」をクリックするとログインページへ遷移すること' do
          click_link 'ログイン画面へ'
          expect(current_path).to eq new_user_session_path
          expect(page).to have_content 'ログイン'
        end
      end

      describe 'ログインページ' do
        before { visit new_user_session_path }

        it '「アカウント登録画面へ」をクリックするとアカウント登録画面へ遷移すること' do
          click_link 'アカウント登録画面へ'
          expect(current_path).to eq new_user_registration_path
          expect(page).to have_content 'アカウント登録'
        end

        it '「パスワードをお忘れの場合はこちら」をクリックするとパスワード再設定ページへ遷移すること' do
          click_link 'パスワードをお忘れの場合はこちら'
          expect(current_path).to eq new_user_password_path
          expect(page).to have_content 'パスワード再設定のメールを送信'
        end
      end
    end

    context 'ログイン後' do
      before { login(user) }

      describe '共通' do
        before { visit posts_path }

        describe 'サイドバー' do
          it 'ユーザーのプロフィール画像が表示されていること' do
            within '.ly_sidebar' do
              expect(page).to have_selector "img[alt='#{user.name}さんのプロフィール写真']"
            end
          end

          it 'ユーザーのプロフィール画像をクリックするとユーザー詳細ページへ遷移すること' do
            within '.ly_sidebar' do
              find('.bl_userInfo a').click
              expect(current_path).to eq user_path(user.id)
            end
          end

          it 'ユーザー名が表示されていること' do
            within '.ly_sidebar' do
              expect(page).to have_selector 'p', text: user.name
            end
          end

          it '「アカウント編集」をクリックするとアカウント編集画面への遷移すること' do
            within ".ly_sidebar" do
              click_link 'アカウント編集'
            end
            expect(current_path).to eq edit_user_registration_path
            expect(page).to have_content 'アカウント編集'
          end

          it '「プロフィール編集」をクリックするとプロフィール編集画面へ遷移すること' do
            within ".ly_sidebar" do
              click_link 'プロフィール編集'
            end
            expect(current_path).to eq profile_users_path
            expect(page).to have_content 'プロフィール編集'
          end

          it '「ログアウト」をクリックするとログアウト後TOPページへ遷移すること' do
            within ".ly_sidebar" do
              click_link 'ログアウト'
            end
            expect(current_path).to eq root_path
            expect(page).to have_content 'ログアウトしました。'
          end
        end

        describe 'ヘッダー' do
          it '「ログアウト」をクリックするとログアウト後TOPページへ遷移すること' do
            within ".ly_header" do
              click_link 'ログアウト'
            end
            expect(current_path).to eq root_path
            expect(page).to have_content 'ログアウトしました。'
          end
        end
      end

      describe 'ユーザー詳細ページ' do
        before { visit user_path(user.id) }

        context '自分の詳細ページ' do
          it '「プロフィール編集」リンクが表示されること' do
            expect(page).to have_content 'プロフィールを編集'
          end
        end

        context '他のユーザーの詳細ページ' do
          it '「プロフィール編集」リンクが表示されないこと' do
            visit user_path(other_user.id)
            expect(page).not_to have_content 'プロフィールを編集'
          end
        end

        context '共通' do
          it 'ページタイトルが表示されていること' do
            expect(page).to have_selector 'h2', text: 'ユーザー詳細'
          end

          it 'ユーザーのプロフィール画像が表示されていること' do
            within '.bl_userInfoContainer' do
              expect(page).to have_selector "img[alt='#{user.name}さんのプロフィール写真']"
            end
          end

          it 'ユーザー名が表示されていること' do
            within '.bl_userInfoContainer' do
              expect(page).to have_selector 'p', text: user.name
            end
          end

          describe 'フォロー情報' do
            before do
              visit user_path(other_user.id)
              click_link 'フォローする'
              visit user_path(user.id)
            end

            it 'フォロー人数が表示されていること' do
              expect(page).to have_selector 'p', text: "#{user.following_user.count}人"
            end

            it 'フォロー情報をクリックするとフォロー一覧ページに遷移すること' do
              all('.bl_followInfo a')[0].click
              expect(current_path).to eq follows_user_path(user)
            end
          end

          describe 'フォロワー情報' do
            before do
              visit user_path(other_user.id)
              click_link 'フォローする'
              visit current_path
            end

            it 'フォロワー人数が表示されていること' do
              expect(page).to have_selector 'p', text: "#{other_user.follower_user.count}人"
            end

            it 'フォロワー人数をクリックするとフォロー一覧ページに遷移すること' do
              all('.bl_followInfo a')[1].click
              expect(current_path).to eq followers_user_path(other_user)
            end
          end

          it '自己紹介が表示されること' do
            expect(page).to have_selector 'p', text: user.introduction
          end

          describe 'ユーザーの投稿' do
            before do
              post.save
              visit current_path
            end

            it 'ユーザーの投稿写真が一覧表示されること' do
              expect(page).to have_selector "img[alt='#{user.name}さんの投稿写真: #{post.id}']"
            end

            it 'ユーザーの投稿写真をクリックすると投稿詳細ページへ遷移すること' do
              link = find('a', id: "user_post_#{post.id}")
              link.click
              expect(page).to have_selector 'h2', text: post.title
              expect(current_path).to eq post_path(post.id)
            end
          end

          describe 'ユーザーのお気に入りの投稿' do
            before do
              other_post.save
              visit posts_path
              find('#favorite-btn').click
              visit user_path(user.id)
            end

            it 'ユーザーのお気に入り投稿写真が一覧表示されること' do
              expect(page).to have_selector "img[alt='#{user.name}さんのお気に入りの投稿写真: #{other_post.id}']"
            end

            it 'ユーザーのお気に入り投稿写真をクリックすると投稿詳細ページへ遷移すること' do
              link = find('a', id: "user_favorite_#{other_post.id}")
              link.click
              expect(page).to have_selector 'h2', text: other_post.title
              expect(current_path).to eq post_path(other_post.id)
            end
          end
        end
      end
    end
  end
end
