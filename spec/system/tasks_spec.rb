require "rails_helper"

describe "タスク", type: :system do
  before do
    @test_user = FactoryBot.create(:user)
    visit login_path
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "P@ssw0rd"
    click_button "ログイン"
  end

  test_task_subject = "テスト用タスク"
  test_task_detail  = "このタスクはテスト用です。"
  test_task_deadline_date = Date.tomorrow
  test_task_deadline_time = Time.zone.now.since(1.hour)

  describe "一覧表示" do
    context "/tasks にアクセス" do
      before do
        visit tasks_path
      end

      it "タスクは表示されない" do
        expect(page.all("tr").count).to eq 1
      end
    end

    context "タスク作成後 /tasks にアクセス" do
      before do
        FactoryBot.create(:task, subject: test_task_subject, detail: test_task_detail, user: @test_user)
        visit tasks_path
      end

      it "作成したタスクが表示" do
        expect(page.all("tr").count).to eq 2
        expect(page).to have_content test_task_subject
      end
    end

    context "タスクを2つ作成後 /tasks にアクセス" do
      before do
        FactoryBot.create(:task, subject: "Former task", detail: "", user: @test_user)
        FactoryBot.create(:task, subject: "Latter task", detail: "", user: @test_user)
        visit tasks_path
      end

      it "後から作成したタスクがより上に表示される" do
        expect(page.all("tr").count).to eq 3
        expect(page).to have_content "Former task"
        expect(page).to have_content "Latter task"
        expect(page.body.index("Former task")).to be > page.body.index("Latter task")
      end
    end
  end

  describe "詳細表示" do
    before do
      FactoryBot.create(:task, subject: test_task_subject, detail: test_task_detail, user: @test_user,
                        deadline_date: test_task_deadline_date, deadline_time: test_task_deadline_time)
    end

    context "タスク作成後タスク詳細画面にアクセス" do
      before do
        visit task_path(Task.last)
      end

      it "作成したタスクの詳細が表示" do
        expect(page).to have_content test_task_subject
        expect(page).to have_content test_task_detail
        expect(page).to have_content test_task_deadline_date.strftime("%Y/%m/%d")
        expect(page).to have_content test_task_deadline_time.to_s(:time)
      end
    end

    context "存在しないタスクの詳細画面にアクセス" do
      before do
        visit task_path(Task.last.id+1)
      end

      it "エラーメッセージが表示" do
        expect(page).to have_content "指定されたタスクは見つかりません。"
      end
    end
  end

  describe "タスク作成" do

    context "新規作成画面でタスクと詳細の両方に入力" do
      before do
        visit new_task_path
        fill_in "タスク", with: test_task_subject
        fill_in "詳細", with: test_task_detail
        click_button "登録する"
      end

      it "正常に登録される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
      end
    end

    context "新規作成画面でタスクのみに入力" do
      before do
        visit new_task_path
        fill_in "タスク", with: test_task_subject
        click_button "登録する"
      end

      it "正常に登録される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
      end
    end

    context "新規作成画面で詳細のみに入力" do
      before do
        visit new_task_path
        fill_in "詳細", with: test_task_detail
        click_button "登録する"
      end

      it "登録に失敗する" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-warning"
        expect(page).not_to have_content test_task_subject
      end
    end
  end

  describe "タスク編集" do
    before do
      FactoryBot.create(:task, subject: test_task_subject, detail: test_task_detail, user: @test_user)
      visit task_path(Task.last)
      click_link "編集"
    end

    new_task_subject = "編集したタスク"
    new_task_detail  = "このタスクはテスト用です。"

    context "編集画面でタスクと詳細の両方を変更" do
      before do
        fill_in "タスク", with: new_task_subject
        fill_in "詳細", with: new_task_detail
        click_button "更新する"
      end

      it "正常に更新される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content new_task_subject
      end
    end

    context "編集画面でタスクのみを変更" do
      before do
        fill_in "タスク", with: new_task_subject
        click_button "更新する"
      end

      it "正常に更新される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content new_task_subject
      end
    end

    context "編集画面で詳細のみを変更" do
      before do
        fill_in "詳細", with: new_task_detail
        click_button "更新する"
      end

      it "正常に更新される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
      end
    end

    context "編集画面でタスクを空欄にする" do
      before do
        fill_in "タスク", with: ""
        click_button "更新する"
      end

      it "更新に失敗する" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-warning"
      end
    end

    context "編集画面で詳細を空欄にする" do
      before do
        fill_in "詳細", with: ""
        click_button "更新する"
      end

      it "正常に更新される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
      end
    end

    context "編集画面で何も変更せず更新する" do
      before do
        click_button "更新する"
      end

      it "正常に更新される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
      end
    end
  end

  describe "タスク削除" do
    before do
      FactoryBot.create(:task, subject: test_task_subject, detail: test_task_detail, user: @test_user)
      visit task_path(Task.last)
    end

    context "削除ボタンを押下する" do
      before do
        click_link "削除"
      end

      it "削除確認のダイアログが表示される" do
        expect(page.driver.browser.switch_to.alert.text).to eq "このタスクを削除しますか？"
      end
    end

    context "ダイアログでOKを選択する" do
      before do
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
      end

      it "タスクが削除される" do
        expect(page).to have_selector "#flash_message"
        expect(page).to have_selector ".alert-info"
        expect(page).not_to have_content test_task_subject
      end
    end

    context "ダイアログでキャンセルを選択する" do
      before do
        click_link "削除"
        page.driver.browser.switch_to.alert.dismiss
      end

      it "タスクが削除されない" do
        expect(page).not_to have_selector "#flash_message"
        expect(page).not_to have_selector ".alert-info"
        expect(page).to have_content test_task_subject
        expect(page).to have_content test_task_detail
      end
    end
  end
end
