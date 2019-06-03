# README

Dockerを利用したRailsの開発環境を用意するための個人用テンプレート。

## 構成

- web
  - nginx:1.16
  - 静的コンテンツの配信とリバースプロキシのためのWebサーバ。
- app
  - ruby:2.6.3, with Node.js 10.x and Ruby on Rails 5.2.3
  - Railsアプリケーションを動かすWebアプリケーションサーバ。
- db
  - postgres:10.8
  - DBサーバ。
- chrome
  - selenium/standalone-chrome:3.141.59
  - RSpec & Capybaraから利用するためのHeadless Chrome。
- mailcatcher
  - mailcatcher:latest
  - 疑似SMTPサーバ。
- data
  - busybox:latest
  - volumesの中身の確認用、手動起動の必要あり。

## 開発を始めるまで

### アプリケーション新規作成

```shell
APPNAME="your_new_application_name"
git clone https://github.com/ha4gu/docker-rails-template.git ${APPNAME}
cd ${APPNAME}
rm -rf .git # テンプレートとしてのコミット履歴を削除
mv README.md HOWTOUSE.md # Readmeファイルのリネーム（rails new実行時に上書きされてしまうため）
rbenv version # ローカル側に指定したバージョンのRubyがインストール済みか確認
rails -v # ローカル側にRailsがインストール済みか確認、なければgem install rails --version="5.2.3"
docker-compose build
rails new . --force --skip-git --skip-bundle --skip-coffee --skip-turbolinks --skip-test -d postgresql
# --force: Gemfileを上書きさせるために必要
# --skip-git: .gitignoreを上書きさせない
# --skip-bundle: このタイミングではまだbundle installを実行させない
# --skip-coffee: CoffeeScriptを使用せず、JavaScriptを使用する
# --skip-turbolinks: Turbolinksを使用しない
# --skip-test: Minitestのためのファイルやディレクトリを作成しない
# -d postgresql: データベースとしてPostgreSQLを使用する
```

### データベース設定の変更

```shell
vim config/database.yml
```

```diff
(略)
 default: &default
   adapter: postgresql
   encoding: unicode
   # For details on connection pooling, see Rails configuration guide
   # http://guides.rubyonrails.org/configuring.html#database-pooling
   pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
+  host: <%= ENV.fetch('DATABASE_HOST') { 'localhost' } %>
+  port: <%= ENV.fetch('DATABASE_PORT') { 5432 } %>
+  username: <%= ENV.fetch('DATABASE_USER') { 'root' } %>
+  password: <%= ENV.fetch('DATABASE_PASSWORD') { 'password' } %>
(略)
```

### タイムゾーンの変更

```shell
vim config/application.rb
```

```diff
(略)
     # -- all .rb files in that directory are automatically loaded after loading
     # the framework and any gems in your application.

     # Don't generate system test files.
     config.generators.system_tests = nil
+
+    # Set JST as the default timezone of Rails
+    config.time_zone = "Asia/Tokyo"
+
+    # Set UTC as the default timezone of ActiveRecord for data stored in DB
+    config.active_record.default_timezone = :utc
   end
 end
```

### Gemfileの用意とDBの作成

```shell
vim Gemfile # edit as you like
```

```Gemfile
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12', '>= 3.12.1'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1', '>= 2.1.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1', '>= 3.1.12'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.9', '>= 4.9.3'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use slim instead of erb
gem 'slim-rails', '~> 3.2'
gem 'html2slim', '~> 0.2.0'

# Use jQuery 3 and Bootstrap 4
# gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
# gem 'bootstrap', '~> 4.3', '>= 4.3.1'

# Use devise for authentication
# gem 'devise', '~> 4.6', '>= 4.6.2'
# gem 'devise-i18n', '~> 1.8'
# gem 'omniauth', '~> 1.9'
# gem 'omniauth-twitter', '~> 1.4'
# gem 'omniauth-facebook', '~> 5.0'
# gem 'omniauth-google-oauth2', '~> 0.6.1'
# gem 'omniauth-github', '~> 1.3'
# gem 'omniauth-instagram', '~> 1.3'

# Use pagy for pagination
# gem 'pagy', '~> 2.1', '>= 2.1.4'

# Use FriendlyId to create pretty URLs
# gem 'friendly_id', '~> 5.2', '>= 5.2.5'

# Use rQRCode for endcoding QR Codes of each room's URL
# gem 'rqrcode', '~> 0.10.1'

# Find url and make it link automatically
# gem 'rails_autolink', '~> 1.1', '>= 1.1.6'

# Use ransack for use of search function
# gem 'ransack', '~> 2.1', '>= 2.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use dotenv for some secure information
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.2'
  # Use factory_bot for generate some test data
  gem 'factory_bot_rails', '~> 5.0', '>= 5.0.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Use RSpec and Capybara with Headless Chrome
  gem 'capybara', '~> 3.22'
  gem 'selenium-webdriver', '~> 3.142', '>= 3.142.3'
  gem 'webdrivers', '~> 4.0'
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
end
```

```shell
docker-compose run --rm app bundle exec rails db:create # 先に自動的にbundle installも実行される
bundle install # ローカルにもGemをインストール (for RubyMine)
rbenv rehash
```

### erbからslim、cssからscssへの変換

```shell
erb2slim app/views/layouts/ --delete
```

```shell
mv app/assets/stylesheets/application.{css,scss}
echo > app/assets/stylesheets/application.scss
```

### Bootstrap 4の有効化

```shell
vim app/assets/stylesheets/application.scss
```

```scss:app/assets/stylesheets/application.scss
// Custom bootstrap variables must be set or imported *before* bootstrap.
@import "bootstrap";

body {
  font-family: -apple-system, BlinkMacSystemFont, YuGothic, "Yu Gothic",
  "Hiragino Sans", "Hiragino Kaku Gothic ProN", "Hiragino Kaku Gothic Pro",
  "Noto Sans CJK JP", "IPA Pゴシック", "IPAPGothic", Meiryo, sans-serif,
  "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
}

//@import "./other-local-scss-file";
```

```shell
vim app/assets/javascripts/application.js
```

```diff
 // This is a manifest file that'll be compiled into application.js, which will include all the files
 // listed below.
 //
 // Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
 // vendor/assets/javascripts directory can be referenced here using a relative path.
 //
 // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 // compiled file. JavaScript code in this file should be added after the last require_* statement.
 //
 // Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
 // about supported directives.
 //
 //= require rails-ujs
 //= require activestorage
 //= require_tree .
+
+// For Bootstrap 4
+//= require jquery3
+//= require popper
+//= require bootstrap-sprockets
```

### ロケールの日本語化

```shell
curl https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -o config/locales/ja.yml
echo "Rails.application.config.i18n.default_locale = :ja" >> config/initializers/locale.rb
```

### ソケットの設定

Railsはデフォルトだと`http://localhost:3000`でListenするように起動する。
しかしこのデフォルトのままだとlocalhost以外からのIPアドレスからアクセスできない。
macOS側から直接ポート3000番へアクセスでき、かつリバースプロキシのためのソケットも有効になるよう、
pumaの設定を変更する。

```shell
vim config/puma.rb
```

```diff
(略)
 # Specifies the `port` that Puma will listen on to receive requests; default is 3000.
 #
-port        ENV.fetch("PORT") { 3000 }
+#port        ENV.fetch("PORT") { 3000 }

 # Specifies the `environment` that Puma will run in.
(略)
 # Allow puma to be restarted by `rails restart` command.
 plugin :tmp_restart
+
+# Listen on 3000/tcp allowing access from any IP address
+bind "tcp://0.0.0.0:3000"
+# And also enable unix domain socket for nginx
+bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
```

これで以下のようになる。

```text
app_1          | => Booting Puma
app_1          | => Rails 5.2.3 application starting in development
app_1          | => Run `rails server -h` for more startup options
app_1          | Puma starting in single mode...
app_1          | * Version 3.12.1 (ruby 2.6.3-p62), codename: Llamas in Pajamas
app_1          | * Min threads: 5, max threads: 5
app_1          | * Environment: development
app_1          | * Listening on tcp://0.0.0.0:3000
app_1          | * Listening on unix:///opt/railsapp/tmp/sockets/puma.sock
app_1          | Use Ctrl-C to stop
```

### テスト起動

```shell
docker-compose up -d # 起動
docker-compose logs -f # リアルタイムログ出力
```

ブラウザからアクセスできることを確認

nginx経由: `http://localhost/`
Rails直接: `http://localhost:3000/`

```shell
docker-compose down # 停止&コンテナ削除 ※Volumeは残るのでデータは消えない
```

## バージョン管理

### Git

```shell
git init
git add -A
git commit -m "Initial commit"
```

### GitHub

先にGitHub上でレポジトリを作成しておく

```shell
git remote set-url origin git@github.com:ha4gu/hogehoge.git
git push -u origin master
```

## テスト

### RSpec

```shell
bin/rails g rspec:install
vim spec/spec_helper.rb
```

```diff
 # See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
+
+require "capybara/rspec"
+Capybara.server_port = "3030"
+Capybara.server_host = Socket.ip_address_list.detect { |addr| addr.ipv4_private? }.ip_address
+
+Capybara.register_driver :selenium_remote do |app|
+  url = "http://chrome:4444/wd/hub"
+  opts = { desired_capabilities: :chrome, browser: :remote, url: url }
+  driver = Capybara::Selenium::Driver.new(app, opts)
+end
+
 RSpec.configure do |config|
+  config.before(:each, type: :system) do
+    driven_by :selenium_remote
+    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
+  end
+
   # rspec-expectations config goes here. You can use an alternate
   # assertion/expectation library such as wrong or the stdlib/minitest
```

```shell
docker-compose run app bundle exec rspec
```

## デプロイ

### Heroku

※Dockerは使用せずにRailsを生で動かすパターン

```bash
heroku create ha4gu-hogehoge
git push heroku master
heroku pg:reset DATABASE # DBの初期化
heroku run rails db:migrate
heroku run rails db:seed
```
