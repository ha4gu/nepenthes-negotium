# タスク管理ツール『タスクカズラ』

## はじめに

このツールは、[株式会社万葉](https://everyleaf.com/)さまが
[GitHubで公開されている新入社員教育用カリキュラム](https://github.com/everyleaf/el-training/blob/master/docs/el-training.md)
をベースとして作成した、タスク管理を行うためのRuby on Railsアプリケーションです。

独学しているためメンターの方はいませんので、
書籍やインターネットで情報を調べながら全て独力で書いたコードとなっています。

現在、課題ステップの実装はほぼ完了しており、
オプション要件や、独自の追加要素を実装しています。

## 作業環境

- 開発環境
  - MacBook Pro Retina 15-inch, Mid 2015
  - macOS Mojave 10.14.6
  - RubyMine 2019.1.3
  - Ruby 2.6.3
  - Ruby on Rails 5.2.3
  - PostgreSQL 10.8
  - Docker 18.09.2
  - Docker Compose 1.23.2
- デプロイ環境
  - Heroku

## 使用している主なgem

- [bcrypt](https://rubygems.org/gems/bcrypt) - パスワードのハッシュ化。今回あえてdeviseを使いませんでした。
- [slim\-rails](https://rubygems.org/gems/slim-rails) - テンプレートエンジンはSlimで記述しています。
- [bootstrap](https://rubygems.org/gems/bootstrap) - CSSフレームワークとして使用。
- [stateful\_enum](https://rubygems.org/gems/stateful_enum) - 状態管理のために導入しましたが有意な使い方ができていません……。
- [pagy](https://rubygems.org/gems/pagy) - ページネーションは定番であるKaminariよりも速いらしいことを知ってこちらに。
- [ransack](https://rubygems.org/gems/ransack) - 検索機能やフィルタリング、結果のソートに使用しています。
- [acts\-as\-taggable\-on](https://rubygems.org/gems/acts-as-taggable-on) - ラベル機能を実装するために使用しています。
- [rubocop](https://rubygems.org/gems/rubocop) - スタイルの統一を心がけています。
- [rspec\-rails](https://rubygems.org/gems/rspec-rails) - テスト用フレームワークです。
- [capybara](https://rubygems.org/gems/capybara) - System SpecをChrome Headlessモードで実行させるのに利用しています。
- [selenium\-webdriver](https://rubygems.org/gems/selenium-webdriver) - 同上。

## 気を付けた要素

- モバイルファーストで作成すること
  - 『iPhone 6のブラウザ画面に収まる』ということを意識して作成しています。
  - 画面サイズの確認にはブラウザの開発者ツールを活用しました。
- ひとりでGitLab flow
  - チーム開発を想定し、GitLab flowを意識したワークフローを実践しました。
  - stagingブランチはありますがproductionブランチがまだありません。（後述）


## 主な独自追加要素

- Docker Composeを使用して開発しています。
  - Docker Composeを使用した[自分用の開発テンプレート](https://github.com/ha4gu/docker-rails-template)を利用しています。
- RSpec + WebDriver + Capibara + Headless Chrome + ChromeのDockerイメージ
  - この組み合わせで、Docker Compose環境でもSystem Spec実行にHeadless Chromeを使えるようにしています。
- CircleCIでのジョブ自動実行
  - featureブランチへのpushやmasterブランチへのmergeのたびに、CircleCI上で自動的にRubocopによるチェックとRSpecによるテストが実行されるようになっています。
  - stagingブランチへのpull requestのたびに、CircleCIから自動的にHerokuへのデプロイが実行されるようになっています。
- チェックボックスのAJAX
  - 各タスクごとにチェックボックスを設け、チェックの付け外しのたびにタスクの状態が切り替わるよう、JavaScriptで実装しています。

## まだ作れていない部分

- 元のカリキュラムにおけるオプション要件のほとんど
- 本番環境を模したデプロイ（AWSへのデプロイをしたい）
  - productionブランチを設け、staging環境への自動デプロイにも問題がない場合にはこのproductionブランチにpull requestを作成しmergeさせることで、本番環境を模したAWSへのデプロイを実行できるようにしたいと考えていました。
- 充分なテストを書くこと
  - 機能の実装を優先したため、テストの量・品質ともに完全に不足しており、テストとして充分な機能を果たせているとは言えない状態です。
  - おかげで実装を変更するたびに飛び火して苦労しています……。
  - 勉強が追いつかない……。

## 名前の由来
- ツール名
  - カリキュラム作成者が株式会社**万葉**さま ⇒ なにか植物に関連した名前をつけたい
  - 『タスクを消化する』というイメージ ⇒ 食虫植物 ⇒ ウツボカズラ
  - `ウツボカズラっぽいタスク管理`をおさまりよくもじる ⇒ "タスクカズラ"
- レポジトリ名
  - ウツボカズラの学名が`Nepenthes rafflesiana`
  - タスクは無理やりラテン語で表すと`negotium` ⇒ "Nepenthes negotium"
