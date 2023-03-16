# Share-Moments.

Share-Moments.は撮影時の設定項目や撮影地を共有できる写真共有アプリケーションです。  
「本格的に写真撮影を趣味としている方々に向けた写真共有アプリケーションが欲しい」という思いから作成に至りました。  
写真を投稿して頂くだけで撮影情報が自動で公開されますので、最小限の手間で撮影情報の共有が可能です。  
撮影地、撮影カメラモデル、タグなどそれぞれの項目毎の検索機能もございますので他のユーザーの投稿もスムーズに探すことができます。  
スマートフォン、タブレットでもご利用頂けます。

URL: https://share-moments.jp  

## TOPページ
- ゲストログイン機能により、アカウントを作成せずにご利用頂くことも可能です。
<img width="1400" alt="スクリーンショット 2023-03-14 14 57 42" src="https://user-images.githubusercontent.com/105051442/224932574-685e85cb-08d0-4021-9bde-26a5bd50f68e.png">  

## 投稿一覧ページ
- サイドバー形式でのナビゲーションメニューで全てのページからメニューをご利用頂けます。
<img width="1400" alt="スクリーンショット 2023-03-14 17 05 18" src="https://user-images.githubusercontent.com/105051442/224935642-bf566c13-38a5-41e7-bf7b-de9646338618.png">  

## 投稿詳細ページ
- 写真を投稿して頂くだけで撮影情報が自動で公開されます(非表示にすることも可能です)
<img width="1400" alt="スクリーンショット 2023-03-14 17 10 14" src="https://user-images.githubusercontent.com/105051442/224936578-46f4e5da-1bcc-4495-8f06-335f0321fde9.png">  
<img width="665" alt="スクリーンショット 2023-03-14 17 52 07" src="https://user-images.githubusercontent.com/105051442/224947009-1866b216-a64f-4e3b-adef-1e543ef6f085.png">

# 機能一覧

- ユーザー関連
  - アカウント登録(編集)、ログイン機能(devise)
  - プロフィール編集
  - フォロー機能  
  - フォロー一覧
  - フォロワー一覧

- 投稿関連
  - 画像投稿(CarrierWave, fog-aws)
  - 投稿写真のExifデータを表示(exifr)
  - Exifデータの位置情報から住所を取得し撮影地を登録(geocoder)
  - 投稿写真の撮影地をGoogle Mapで表示(Google Maps API)
  - お気に入り機能(非同期通信)
  - お気に入り投稿一覧
  - フォローしたユーザーの投稿一覧
  - コメント機能
  - 検索機能
    - フリーワード検索
    - 撮影地別検索
    - カメラモデル別検索
    - タグ別検索

- その他
  - レスポンシブ対応
    - PC
    - タブレット
    - スマートフォン

# 使用技術

- AWS
  - VPC
  - EC2
  - RDS(MySQL8.0)
  - S3
  - Route53
  - ELB(ALB)
- Docker/Docker-compose
- GitHub Actions
- Ruby 3.0.5
- Ruby on Rails 6.1.7
- RSpec
- Google Maps API

# AWS構成図
- 開発環境はDockerで構築
- GitHubにpush時、GitHubActionsで構文確認(Rubocop)とテスト(Rspec)を通し、パスした場合のみEC2へ自動デプロイ
- 本番環境でのデータはRDS(MySQL)に保存(アップロードされた画像データはS3に保存)
- ELB(ALB)によりユーザーとの通信を暗号化(httpsに変換)
![インフラ構成図_share-momens drawio (1)](https://user-images.githubusercontent.com/105051442/224930160-8912e3b1-2055-4dc5-9565-11c6f88950bd.png)

# ER図
- User: ユーザー
- Post: 投稿
- Tag: タグ
- Relationship: フォロー機能
- Favorite: お気に入り投稿機能
- Comment: コメント機能
- TagMap: タグ機能(投稿とタグを関連づけ)
- Prefecture: 都道府県
<img width="792" alt="スクリーンショット 2023-03-14 17 16 43" src="https://user-images.githubusercontent.com/105051442/224938339-d95284b4-44bd-4148-8aa2-aba308a796b0.png">

# テスト(Rspec)

- 単体テスト(Model Spec)
- 統合テスト(System Spec)
