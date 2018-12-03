require 'rails_helper'

RSpec.feature "ユーザー機能", type: :feature do
  let(:now) { Date.current }
  background do
    FactoryBot.create(:user, id: 12)
    FactoryBot.create(:user, id: 13, 
                      name: "Owen", 
                      email: "owen@email.com", 
                      password: "password"
                      )

    FactoryBot.create(:task, 
                      user_id: 12,
                      title: "美容室",
                      content: "16時から", 
                      expired_at: "#{now}", 
                      state: 2, priority: 0, 
                      created_at: "#{Date.current.yesterday}"
                      )
    FactoryBot.create(:task,
                      user_id: 13, 
                      title: "歯医者", 
                      content: "18時から", 
                      expired_at: "#{now}", 
                      state: 0, priority: 1, 
                      created_at: "#{Date.current.ago(2.day)}"
                      )
  end

  scenario "ユーザー登録(登録と同時にログイン)のテスト" do
    visit root_path
    click_on "登録"

    fill_in '名前', with: "John"
    fill_in 'メールアドレス', with: "john@email.com"
    fill_in 'パスワード', with: "password"
    fill_in '確認用パスワード', with: "password"

    click_on "登録する"
    expect(page).to have_content "ログアウト"
    expect(page).to have_content "John"
    expect(page).to have_content "john@email.com"
  end

  scenario "ログイン/ログアウトのテスト" do
    visit root_path
    click_on 'ログイン'

    fill_in 'session[email]', with: "jensen@email.com"
    fill_in 'session[password]', with: "password"

    within ".login_button" do
      click_on "ログイン"
    end

    expect(page).to have_content "タスクを登録しましょう！"
    
    click_on "ログアウト"
    expect(page).to have_content "ログアウトしました"
    expect(page).to have_content "Welcome to Awesome Manager"
  end

  scenario "ログインなしではタスクページへ飛べないテスト" do
    visit tasks_path
    
    expect(page).to have_content "ログイン"
    expect(page).to have_content "メールアドレス"
    expect(page).to have_content "パスワード"
  end

  scenario "ログインしていると登録画面へ飛べないテスト" do
    visit root_path
    click_on 'ログイン'

    fill_in 'session[email]', with: "jensen@email.com"
    fill_in 'session[password]', with: "password"

    within ".login_button" do
      click_on "ログイン"
    end

    visit new_user_path
    expect(page).to have_content "すでに登録済みです"
  end

  scenario "自分以外のマイページへ飛べないテスト" do
    visit root_path
    click_on 'ログイン'

    fill_in 'session[email]', with: "jensen@email.com"
    fill_in 'session[password]', with: "password"

    within ".login_button" do
      click_on "ログイン"
    end

    visit user_path(13)
    expect(page).to have_content "権限がありません"
  end
  
  scenario "自分のタスクのみ表示されるかのテスト" do
    visit root_path
    click_on 'ログイン'

    fill_in 'session[email]', with: "jensen@email.com"
    fill_in 'session[password]', with: "password"

    within ".login_button" do
      click_on "ログイン"
    end
    
    visit tasks_path
    expect(page).not_to have_content "歯医者"
  end
end