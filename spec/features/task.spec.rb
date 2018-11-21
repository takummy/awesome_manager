require 'rails_helper'

RSpec.feature  "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:task)
    FactoryBot.create(:task, title: "美容室", content: "16時から")
    FactoryBot.create(:task, title: "歯医者", content: "18時から")
    FactoryBot.create(:task, title: "飲み会予約", content: "海浜幕張のちばチャン19時〜")
    FactoryBot.create(:task, title: "新幹線の予約", content: "東京駅10時発のやつ")
  end
  scenario "タスク一覧のテスト" do
    visit root_path

    expect(page).to have_content "歯医者"
    expect(page).not_to have_content "借金の返済"
  end

  scenario "タスク作成のテスト" do
    visit new_task_path

    fill_in 'タスク名', with: "DIC"
    fill_in '内容', with: "オリアプを完成させる"

    click_on "登録する"
    
    expect(page).to have_content "DIC"
    expect(page).to have_content "オリアプを完成させる"
  end

  let(:task) { Task.create!(title: "もくもく会", content: "15時〜五反田") }
  scenario "タスク詳細のテスト" do
    visit task_path(task.id)

    expect(page).to have_content "もくもく会"
    expect(page).to have_content "15時〜五反田"
  end

  scenario "タスク一覧が作成日時順に並んでいるかのテスト" do
    visit root_path
    
    task = all('tr td')
    expect(task[0]).not_to have_text 'Amazon定期便'
    expect(task[6]).to have_text '海浜幕張のちばチャン19時〜'

    task[12].click_on '詳細'
    expect(page).to have_selector 'h3', text: '18時から'
  end
end