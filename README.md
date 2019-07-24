# README



- 万葉の研修をベースにしてやってる
- 今xxxxのところまで作ったほか、独自要素を複数追加している


- 使用しているgem
- こだわっている要素
  - モバイルファースト（iPhone 6でも見やすいように）
  - ひとりでGitLab flow
    - productionブランチがまだないのは後述
  - あえてアカウント管理のgemを使っていません
- 独自追加要素
  - Docker Composeを使用
  - Capibara + Headless Chrome + RSpec
  - circle ci
  - チェックボックスAJAX
  - 日付の細かい挙動
- 名前の由来

- また作れていない部分
  - 元のリストの残り
  - 本番環境を模したデプロイ（AWSへのデプロイをしたかった）
  - まともなテスト（今のところModel Specばかり）
