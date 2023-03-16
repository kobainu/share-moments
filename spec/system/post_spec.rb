require 'rails_helper'

RSpec.describe Post, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, name: 'other_user') }
  let(:other_user_2) { create(:user) }
  let(:pic_path) { Rails.root.join('spec/fixture/image.jpg') }
  let(:photo) { Rack::Test::UploadedFile.new(pic_path) }
  let(:post) { create(:post, user_id: user.id, photo: photo) }
  let(:other_post) { create(:post, user_id: other_user.id, photo: photo) }
  let(:other_post_2) { create(:post, user_id: other_user_2.id, photo: photo) }
  let(:tag) { create(:tag) }
  let(:tag_map) { create(:tag_map, tag_id: tag.id, post_id: post.id) }

  before { login(user) }

  describe 'Post CRUD' do
    describe '投稿作成' do
      before { visit new_post_path }

      context 'フォームの入力値が正常' do
        it '投稿が成功すること' do
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
      before { visit edit_post_path(post.id) }

      context 'フォームの入力値が正常' do
        it '投稿の編集が成功すること' do
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

  describe 'view' do
    describe '共通' do
      before { visit posts_path }

      describe 'ヘッダー' do
        it 'アプリケーションのロゴが表示されていること' do
          within ".ly_header" do
            expect(page).to have_selector 'h1', text: 'Share-Moments.'
          end
        end

        it 'アプリケーションのロゴをクリックすると投稿一覧ページに遷移すること' do
          within ".ly_header" do
            click_link 'Share-Moments.'
          end
          expect(current_path).to eq posts_path
        end

        it 'フリーワード検索フォームが表示されていること' do
          within ".ly_header" do
            expect(page).to have_selector 'form'
          end
        end

        it 'フリーワード検索フォームに入力したキーワードを(住所 or カメラ名に)含む投稿のみが表示されること' do
          @post_in_tokyo = create(:post, address: 'Tokyo', photo: photo)
          @post_in_osaka = create(:post, address: 'Osaka', photo: photo)
          within ".ly_header" do
            fill_in 'フリーワードで検索', with: 'Tokyo'
            find('#search-btn').click
          end
          expect(current_path).to eq search_posts_path
          within ".ly_main_inner" do
            expect(page).to have_selector "img[alt='投稿写真: #{@post_in_tokyo.id}']"
            expect(page).not_to have_selector "img[alt='投稿写真: #{@post_in_osaka.id}']"
          end
        end

        it '「投稿する」ボタンが表示されていること' do
          within ".ly_header" do
            expect(page).to have_selector 'a', text: '投稿する'
          end
        end

        it '「投稿する」ボタンをクリックすると投稿作成ページに遷移すること' do
          within ".ly_header" do
            click_link '投稿する'
          end
          expect(current_path).to eq new_post_path
          expect(page).to have_selector 'h2', text: '新規投稿'
        end
      end

      describe 'サイドバー' do
        it 'ナビメニュー「投稿する」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'a', text: '投稿する'
          end
        end

        it 'ナビメニュー「投稿する」をクリックすると投稿作成ページに遷移すること' do
          within ".ly_sidebar" do
            click_link '投稿する'
          end
          expect(current_path).to eq new_post_path
          expect(page).to have_selector 'h2', text: '新規投稿'
        end

        it 'ナビメニュー「全ての投稿」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'a', text: '全ての投稿'
          end
        end

        it 'ナビメニュー「全ての投稿」をクリックすると投稿一覧ページに遷移すること' do
          within ".ly_sidebar" do
            click_link '全ての投稿'
          end
          expect(current_path).to eq posts_path
          expect(page).to have_selector 'h2', text: '全ての投稿'
        end

        it 'ナビメニュー「お気に入りの投稿」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'a', text: 'お気に入りの投稿'
          end
        end

        it 'ナビメニュー「お気に入りの投稿」をクリックするとお気に入りの投稿一覧ページに遷移すること' do
          within ".ly_sidebar" do
            click_link 'お気に入りの投稿'
          end
          expect(current_path).to eq favorite_index_posts_path
          expect(page).to have_selector 'h2', text: 'お気に入りの投稿'
        end

        it 'ナビメニュー「フォロー中のユーザーの投稿」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'a', text: "フォロー中の"
          end
        end

        it 'ナビメニュー「フォロー中のユーザーの投稿」をクリックするとフォロー中のユーザーの投稿一覧ページに遷移すること' do
          within ".ly_sidebar" do
            click_link 'フォロー中の'
          end
          expect(current_path).to eq following_posts_path
          expect(page).to have_selector 'h2', text: 'フォロー中のユーザーの投稿'
        end

        it 'ナビメニュー「撮影地で探す」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'li', text: "撮影地で探す"
          end
        end

        it 'ナビメニュー「タグで探す」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'li', text: "タグで探す"
          end
        end

        it 'ナビメニュー「カメラ名で探す」が表示されていること' do
          within ".ly_sidebar" do
            expect(page).to have_selector 'li', text: "カメラ名で探す"
          end
        end
      end
    end

    describe '全ての投稿一覧ページ' do
      before do
        post.save
        visit posts_path
      end

      it '投稿した写真が表示されていること' do
        within ".bl_card" do
          expect(page).to have_selector "img[alt='投稿写真: #{post.id}']"
        end
      end

      it '投稿した写真に投稿ユーザー名が表示されていること' do
        within ".bl_card" do
          expect(page).to have_content post.user.name
        end
      end

      it '投稿写真をクリックすると投稿詳細ページへ遷移すること' do
        within ".bl_card" do
          click_on "投稿写真"
        end
        expect(current_path).to eq post_path(post.id)
        expect(page).to have_content post.title
      end

      context '自分の投稿' do
        it 'お気に入りボタンが表示されないこと' do
          expect(page).not_to have_selector 'a', id: 'favorite-btn'
        end
      end

      context '他のユーザーの投稿' do
        it 'お気に入りボタンが表示されること' do
          post.destroy
          other_post.save
          visit posts_path
          expect(page).to have_selector 'a', id: 'favorite-btn'
        end
      end
    end

    describe 'お気に入り投稿一覧ページ' do
      before do
        @favorite_post = other_post
        @unfavorite_post = other_post_2
        visit posts_path
        all('#favorite-btn')[1].click
        visit favorite_index_posts_path
      end

      it 'お気に入り登録している投稿が表示されていること' do
        expect(page).to have_selector "img[alt='投稿写真: #{@favorite_post.id}']"
      end

      it 'お気に入り登録していない投稿が表示されていないこと' do
        expect(page).not_to have_selector "img[alt='投稿写真: #{@unfavorite_post.id}']"
      end
    end

    describe 'フォロー中のユーザーの投稿一覧ページ' do
      before do
        @following_users_post = other_post
        @unfollowing_users_post = other_post_2
        visit post_path(@following_users_post.id)
        first('.bl_followBtn a').click
        visit following_posts_path
      end

      it 'フォロー中のユーザーの投稿が表示されていること' do
        expect(page).to have_selector "img[alt='投稿写真: #{@following_users_post.id}']"
      end

      it 'フォローしていないユーザーの投稿が表示されていないこと' do
        expect(page).not_to have_selector "img[alt='投稿写真: #{@unfollowing_users_post.id}']"
      end
    end

    describe '投稿詳細ページ' do
      before do
        tag_map.save
        @post = post
        @post.camera = @post.photo.camera
        @post.lens = @post.photo.lens_model
        @post.exposure_time = @post.photo.exposure_time
        @post.f_number = @post.photo.f_number
        @post.iso_speed_ratings = @post.photo.iso_speed_ratings
        @post.exposure_bias_value = @post.photo.exposure_bias_value
        @post.focal_length = @post.photo.focal_length
        @post.shooting_date_time = @post.photo.date_time_original
        @post.address = 'address'
        @post.latitude = 35.0395
        @post.longitude = 135.728
        @post.save
        visit post_path(@post.id)
      end

      context '自分の投稿' do
        it '「投稿を編集」リンクが表示されていること' do
          expect(page).to have_selector 'a', text: '投稿を編集'
        end

        it 'フォローボタンが表示されていないこと' do
          expect(page).not_to have_selector '.bl_followBtn a', text: 'フォローする'
        end
      end

      context '他のユーザーの投稿' do
        before { visit post_path(other_post.id) }

        it '「投稿編集」リンクが表示されていないこと' do
          expect(page).not_to have_selector 'a', text: '投稿を編集'
        end

        it 'フォローボタンが表示されていること' do
          expect(page).to have_selector '.bl_followBtn a', text: 'フォローする'
        end
      end

      context '共通' do
        it 'タイトルが表示されていること' do
          expect(page).to have_selector 'h2', text: @post.title
        end

        it '投稿写真が表示されていること' do
          expect(page).to have_selector "img[alt='投稿写真: #{@post.id}']"
        end

        it 'タグが表示されていること' do
          expect(page).to have_selector 'span', text: 'test_tag'
        end

        it 'タグをクリックするとタグ検索投稿一覧ページに遷移すること' do
          click_on 'test_tag'
          expect(current_path).to eq tag_search_posts_path
        end

        it '投稿ユーザーのプロフィール写真が表示されていること' do
          expect(page).to have_selector "img[alt='#{@post.user.name}さんのプロフィール写真']"
        end

        it '投稿ユーザーのユーザー名が表示されていること' do
          expect(page).to have_selector 'p', text: @post.user.name
        end

        it '「カメラ名」が表示されていること' do
          expect(page).to have_selector 'a', text: @post.camera
        end

        it '「カメラ名」をクリックすると同じカメラで撮影された投稿のみの一覧が表示されること' do
          @same_camera_post = create(:post, camera: @post.camera, photo: photo)
          @different_camera_post = create(:post, camera: 'different_camera', photo: photo)
          all('#post-camera')[1].click
          expect(current_path).to eq camera_search_posts_path
          expect(page).to have_selector "img[alt='投稿写真: #{@post.id}']"
          expect(page).to have_selector "img[alt='投稿写真: #{@same_camera_post.id}']"
          expect(page).not_to have_selector "img[alt='投稿写真: #{@different_camera_post.id}']"
        end

        it '「レンズ名」が表示されていること' do
          expect(page).to have_selector 'p', text: @post.lens
        end

        it '「シャッタースピード」が表示されていること' do
          expect(page).to have_selector 'p', text: @post.exposure_time
        end

        it '「絞り」が表示されていること' do
          expect(page).to have_selector 'p', text: @post.f_number
        end

        it '「ISO感度」が表示されていること' do
          expect(page).to have_selector 'p', text: @post.iso_speed_ratings
        end

        it '「露出補正値」が表示されていること' do
          expect(page).to have_selector 'p', text: "#{@post.exposure_bias_value.to_r.to_f.round(1)}EV"
        end

        it '「焦点距離」が表示されていること' do
          expect(page).to have_selector 'p', text: "#{@post.focal_length}mm"
        end

        it '「撮影日時」が表示されていること' do
          expect(page).to have_selector 'p', text: "#{@post.shooting_date_time.to_time.strftime("%Y年 %m月%d日 %H時%M分")}"
        end

        context '撮影地情報が存在する' do
          it '撮影地がGoogle-mapで表示されること' do
            expect(page).to have_selector '#location-map'
          end

          it '撮影地を非表示に設定した場合、撮影地が表示されないこと' do
            expect(page).to have_selector '#location-map'
            visit edit_post_path(@post.id)
            check 'post[hide_location_info]'
            click_button '投稿を更新'
            visit post_path(@post.id)
            expect(page).not_to have_selector '#location-map'
          end
        end

        context '撮影地情報が存在しない' do
          it '撮影地がGoogle-mapで表示されないこと' do
            @post.latitude = nil
            @post.longitude = nil
            @post.save
            visit current_path
            expect(page).not_to have_selector '#location-map'
          end
        end

        it '投稿ユーザーの他の投稿写真が表示されていること' do
          @other_post = create(:post, user_id: @post.user_id, photo: photo)
          visit current_path
          expect(page).to have_selector "img[alt='#{@post.user.name}さんの他の投稿写真: #{@other_post.id}']"
          expect(page).not_to have_selector "img[alt='#{@post.user.name}さんの他の投稿写真: #{@post.id}']"
        end

        it '投稿ユーザーの他の投稿写真をクリックすると、対象の投稿詳細ページに遷移すること' do
          @other_post = create(:post, user_id: @post.user_id, photo: photo, title: 'other')
          visit current_path
          within first('.bl_postDetail_secondaryImgContainer') do
            link = find('a', id: "other_post_#{@other_post.id}")
            link.click
          end
          expect(page).to have_selector 'h2', text: @other_post.title
          expect(current_path).to eq post_path(@other_post.id)
        end

        it 'コメントを送信すると、コメントの内容とコメントしたユーザーの情報が表示されること' do
          fill_in 'comment[comment]', with: 'comment'
          click_button '送信する'
          within '.bl_comment' do
            expect(page).to have_selector "img[alt='#{user.name}さんのプロフィール写真']"
            expect(page).to have_selector 'p', text: user.name
            expect(page).to have_selector 'p', text: 'comment'
          end
        end

        it 'コメントの「削除」ボタンをクリックするとコメントが削除されること' do
          fill_in 'comment[comment]', with: 'comment'
          click_button '送信する'
          within '.bl_comment' do
            expect(page).to have_selector "img[alt='#{user.name}さんのプロフィール写真']"
            expect(page).to have_selector 'p', text: user.name
            expect(page).to have_selector 'p', text: 'comment'
            click_link '削除'
          end
          expect do
            expect(page.accept_confirm).to eq "コメントを削除しますか？"
            expect(page).to have_content "コメントを削除しました。"
          end
          expect(page).not_to have_selector '.bl_comment'
        end
      end
    end

    describe '投稿編集ページ' do
      before { visit edit_post_path(post.id) }

      it 'ページタイトルが表示されていること' do
        expect(page).to have_selector 'h2', text: '投稿内容の編集'
      end

      it '投稿写真が表示されていること' do
        expect(page).to have_selector "img[alt='投稿写真: #{post.id}']"
      end

      it '「投稿を削除」ボタンが表示されていること' do
        expect(page).to have_selector 'a', text: '投稿を削除'
      end

      it '「投稿を削除」ボタンをクリックすると投稿が削除されること' do
        click_link '投稿を削除'
        expect do
          expect(page.accept_confirm).to eq "削除すると復元できません。よろしいですか？"
          expect(page).to have_content "投稿を削除しました。"
        end
        expect(current_path).to eq posts_path
        expect(page).not_to have_selector "img[alt='投稿写真: #{post.id}']"
      end

      it '「投稿を更新」ボタンが表示されていること' do
        expect(page).to have_button '投稿を更新'
      end
    end
  end
end
