require 'rails_helper'

RSpec.feature "管理者機能", type: :feature do
  let(:now) { Date.current }
  background do
    user_1 = FactoryBot.create(:user, admin: true)
    user_2 = FactoryBot.create(:user,
                               name: "Owen", 
                               email: "owen@email.com", 
                               password: "password",
                               admin: false
                               )
    FactoryBot.create(:task, 
                      user_id: user_1.id,
                      title: "美容室",
                      content: "16時から", 
                      expired_at: "#{now}", 
                      state: 2, priority: 0, 
                      created_at: "#{Date.current.yesterday}"
                      )
    FactoryBot.create(:task,
                      user_id:  user_1.id, 
                      title: "歯医者", 
                      content: "18時から", 
                      expired_at: "#{now}", 
                      state: 2, priority: 2, 
                      created_at: "#{Date.current.ago(2.day)}"
                      )
    FactoryBot.create(:task,
                      user_id:  user_2.id, 
                      title: "飲み会", 
                      content: "錦糸町", 
                      expired_at: "#{now}", 
                      state: 2, priority: 1, 
                      created_at: "#{Date.current.ago(2.day)}"
                      )
    visit root_path
    click_on 'ログイン'

    fill_in "session[email]", with: "jensen@email.com"
    fill_in "session[password]", with: "password"

    within ".login_button" do
      click_on "ログイン"
    end
  end

  scenario "ユーザー一覧のテスト" do
    visit admin_users_path
    expect(page).to have_content "タスク数"
  end

  scenario "新規ユーザー作成のテスト" do
    visit new_admin_user_path

    fill_in "user[name]", with: "John"
    fill_in "user[email]", with: "john@email.com"
    check "Admin"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_on "登録する"
    
    expect(page).to have_content "Johnを登録しました！"
  end

  scenario "ユーザー詳細画面にユーザーのタスク一覧が表示されるテスト" do
    click_on "ユーザー一覧"
    click_on "Owen"
    task_info = all('tr th')
    expect(task_info[0]).to have_text "タスク名"
    expect(task_info[1]).to have_text "内容"
    expect(task_info[2]).to have_text "終了期限"
    expect(task_info[3]).to have_text "進捗"
    expect(task_info[4]).to have_text "優先順位"
  end

  scenario "ユーザー情報の更新をテスト(管理者権限を付与)" do
    click_on "ユーザー一覧"
    click_on "Owen"
    expect(page).not_to have_content "(管理者)"

    button = first('a', text: "編集")
    button.click
    check "Admin"
    fill_in "user[password]", with: "password"
    fill_in "user[password_confirmation]", with: "password"
    click_on "更新"
    expect(page).to have_content "(管理者)"
  end

  scenario "ユーザー削除のテスト" do
    click_on "ユーザー一覧"

    user = User.find_by(name: "Owen")
    names = User.all.pluck(:name)
    titles = Task.all.where(user_id: user.id).pluck(:title)
    expect(names).to include "Owen"
    expect(titles).to include "飲み会"

    button = all('a', text: "削除")
    button[1].click
    expect(page).to have_content "Owenを削除しました！"

    names = User.all.pluck(:name)
    titles = Task.all.where(user_id: user.id).pluck(:title)
    expect(names).not_to include "Owen"
    expect(titles).not_to include "飲み会"
  end
end