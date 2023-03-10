require 'rails_helper'

RSpec.describe Post, type: :system do
  let(:user) { create(:user) }
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { create(:post, user_id: user.id, photo: photo) }

  describe 'Post CRUD' do
    before { login(user) }

    describe '投稿作成' do
      context 'フォームの入力値が正常' do
        it '投稿が成功すること' do
          visit posts_path
          within ".ly_header" do
            click_link '投稿する'
          end
          attach_file 'post[photo]', Rails.root.join('spec/fixture/image.jpg')
          fill_in 'post[title]', with: 't' * 20
          fill_in 'post[description]', with: 'd' * 150
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿する'
          expect(page).to have_content '投稿が完了しました。'
        end
      end

      context '投稿写真が指定されていない' do
        it '投稿が失敗すること' do
          visit posts_path
          within ".ly_header" do
            click_link '投稿する'
          end
          fill_in 'post[title]', with: 't' * 20
          fill_in 'post[description]', with: 'd' * 150
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿する'
          expect(page).to have_content '投稿に失敗しました。'
          expect(page).to have_content '投稿する写真を選択して下さい。'
        end
      end

      context 'タイトルが未記入' do
        it '投稿が失敗すること' do
          visit posts_path
          within ".ly_header" do
            click_link '投稿する'
          end
          attach_file 'post[photo]', Rails.root.join('spec/fixture/image.jpg')
          fill_in 'post[title]', with: ''
          fill_in 'post[description]', with: 'd' * 150
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿する'
          expect(page).to have_content '投稿に失敗しました。'
          expect(page).to have_content 'タイトルを入力して下さい。'
        end
      end

      context 'タイトルが21文字以上' do
        it '投稿が失敗すること' do
          visit posts_path
          within ".ly_header" do
            click_link '投稿する'
          end
          attach_file 'post[photo]', Rails.root.join('spec/fixture/image.jpg')
          fill_in 'post[title]', with: 't' * 21
          fill_in 'post[description]', with: 'd' * 150
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿する'
          expect(page).to have_content '投稿に失敗しました。'
          expect(page).to have_content 'タイトルは20文字以内で入力して下さい。'
        end
      end

      context '投稿紹介が151文字以上' do
        it '投稿が失敗すること' do
          visit posts_path
          within ".ly_header" do
            click_link '投稿する'
          end
          attach_file 'post[photo]', Rails.root.join('spec/fixture/image.jpg')
          fill_in 'post[title]', with: 't' * 20
          fill_in 'post[description]', with: 'd' * 151
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿する'
          expect(page).to have_content '投稿に失敗しました。'
          expect(page).to have_content '投稿紹介は150文字以内で入力して下さい。'
        end
      end
    end

    describe '投稿編集' do
      context 'フォームの入力値が正常' do
        it '投稿の編集が成功すること' do
          visit edit_post_path(post.id)
          fill_in 'post[title]', with: 'title_edit'
          fill_in 'post[description]', with: 'description_edit'
          fill_in 'post[tag_name]', with: 'tag_edit'
          click_button '投稿を更新'
          expect(current_path).to eq post_path(post.id)
          expect(page).to have_content '投稿内容を更新しました。'
        end
      end

      context 'タイトルが未記入' do
        it '投稿の編集が失敗すること' do
          visit edit_post_path(post.id)
          fill_in 'post[title]', with: ''
          fill_in 'post[description]', with: 'description_edit'
          fill_in 'post[tag_name]', with: 'tag_edit'
          click_button '投稿を更新'
          expect(page).to have_content '更新に失敗しました。'
          expect(page).to have_content 'タイトルを入力して下さい。'
        end
      end

      context 'タイトルが21文字以上' do
        it '投稿の編集が失敗すること' do
          visit edit_post_path(post.id)
          fill_in 'post[title]', with: 't' * 21
          fill_in 'post[description]', with: 'd' * 150
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿を更新'
          expect(page).to have_content '更新に失敗しました。'
          expect(page).to have_content 'タイトルは20文字以内で入力して下さい。'
        end
      end

      context '投稿紹介が151文字以上' do
        it '投稿の編集が失敗すること' do
          visit edit_post_path(post.id)
          fill_in 'post[title]', with: 't' * 20
          fill_in 'post[description]', with: 'd' * 151
          fill_in 'post[tag_name]', with: 'tag'
          click_button '投稿を更新'
          expect(page).to have_content '更新に失敗しました。'
          expect(page).to have_content '投稿紹介は150文字以内で入力して下さい。'
        end
      end
    end
  end
end
