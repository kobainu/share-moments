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

  describe 'view' do
    before do
      login(user)
      post.save
    end

    describe '投稿一覧画面' do
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

        # it '撮影地検索フォームが表示されていること' do
        #   find('#test').trigger(:mouseover)
        #   expect(page).to have_selector 'h3', text: '撮影地で探す'
        # end

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

      describe 'メインコンテンツエリア' do
        it '投稿した写真と投稿者のユーザー名が表示されていること' do
          within ".bl_card" do
            expect(page).to have_selector "img[alt='投稿写真: #{post.id}']"
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

    # describe '撮影地検索結果一覧ページ' do
    # end

    # describe 'カメラ名検索結果一覧ページ' do
    # end

    # describe 'タグ検索結果一覧ページ' do
    # end

    describe '投稿詳細ページ' do
      before do
        @post = post
        @post.camera = @post.photo.camera
        @post.lens = @post.photo.lens_model
        @post.exposure_time = @post.photo.exposure_time
        @post.f_number = @post.photo.f_number
        @post.iso_speed_ratings = @post.photo.iso_speed_ratings
        @post.exposure_bias_value = @post.photo.exposure_bias_value
        @post.focal_length = @post.photo.focal_length
        @post.shooting_date_time = @post.photo.date_time_original
        @post.latitude = 35.0395
        @post.longitude = 135.728
        @post.save
        visit post_path(@post.id)
      end

      context '自他共通' do
        it 'タイトルが表示されていること' do
          expect(page).to have_selector 'h2', text: @post.title
        end

        it '投稿写真が表示されていること' do
          expect(page).to have_selector "img[alt='投稿写真: #{@post.id}']"
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

        it '投稿写真に位置情報が存在する場合、撮影地がGoogle-mapで表示されていること' do
          expect(page).to have_selector '#location-map'
        end

        it '投稿写真に位置情報が存在しない場合、撮影地がGoogle-mapで表示されていないこと' do
          @post.latitude = nil
          @post.longitude = nil
          @post.save
          visit current_path
          expect(page).not_to have_selector '#location-map'
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

      context '自分の投稿' do
        it '「投稿編集」リンクが表示されていること' do
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
    end

    describe '画面遷移' do
      describe 'ヘッダーメニューからの遷移' do
        before  { visit posts_path }

        context '投稿作成ページへの遷移' do
          it '「投稿する」をクリック' do
            within '.ly_header' do
              click_link '投稿する'
            end
            expect(current_path).to eq new_post_path
            expect(page).to have_content '新規投稿'
          end
        end
      end

      describe 'サイドバーメニューからの遷移' do
        before  { visit posts_path }

        context '投稿作成ページへの遷移' do
          it '「投稿する」をクリック' do
            within '.ly_sidebar' do
              click_link '投稿する'
            end
            expect(current_path).to eq new_post_path
            expect(page).to have_content '新規投稿'
          end
        end

        context '全ての投稿ページへの遷移' do
          it '「全ての投稿」をクリック' do
            within '.ly_sidebar' do
              click_link '全ての投稿'
            end
            expect(current_path).to eq posts_path
            expect(page).to have_content '全ての投稿'
          end
        end

        context 'お気に入りの投稿ページへの遷移' do
          it '「お気に入りの投稿」をクリック' do
            within '.ly_sidebar' do
              click_link 'お気に入りの投稿'
            end
            expect(current_path).to eq favorite_index_posts_path
            expect(page).to have_content 'お気に入りの投稿'
          end
        end

        context 'フォロー中のユーザーの投稿ページへの遷移' do
          it '「フォロー中のユーザーの投稿」をクリック' do
            within '.ly_sidebar' do
              click_link 'フォロー中の'
            end
            expect(current_path).to eq following_posts_path
            expect(page).to have_content 'フォロー中のユーザーの投稿'
          end
        end
      end
    end
  end
end
