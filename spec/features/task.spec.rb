require 'rails_helper'

RSpec.feature  "タスク管理機能", type: :feature do
  let(:now) { Date.current }
  background do
    FactoryBot.create(:task)
    FactoryBot.create(:task, title: "美容室", content: "16時から", expired_at: "#{now}", state: 2)
    FactoryBot.create(:task, title: "歯医者", content: "18時から", expired_at: "#{now}", state: 0)
    FactoryBot.create(:task, title: "飲み会予約", content: "海浜幕張のちばチャン19時〜", expired_at: "#{now.since(1.week)}", state: 1)
    FactoryBot.create(:task, title: "新幹線の予約", content: "東京駅10時発のやつ", expired_at: "#{now}", state: 0)
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
    select '2018', from: 'task_expired_at_1i'
    select '12', from: 'task_expired_at_2i'
    select '25', from: 'task_expired_at_3i'
    choose 'task_state_waiting'
    
    click_on "登録する"
    
    expect(page).to have_content "DIC"
    expect(page).to have_content "オリアプを完成させる"
    expect(page).to have_content "2018-12-25"
    expect(page).to have_content "未着手"
  end

  let(:task) { Task.create!(title: "もくもく会", content: "15時〜五反田", expired_at: "#{now}", state: 0) }
  scenario "タスク詳細のテスト" do
    visit task_path(task.id)
    
    expect(page).to have_content "もくもく会"
    expect(page).to have_content "15時〜五反田"
    expect(page).to have_content "#{now}"
    expect(page).to have_content "未着手"
  end

  feature "タスクの並び順" do
    let(:task) { all('tr td') }
    scenario "タスク一覧が作成日時順に並んでいるかのテスト" do
      visit root_path
      
      expect(task[0]).not_to have_text '歯医者'
      expect(task[7]).to have_text '美容室'

      task[25].click_on '詳細'
      expect(page).to have_selector 'h3', text: '海浜幕張のちばチャン19時〜'
    end

    scenario "タスクが終了期限順に並び変わるかのテスト" do
      visit root_path

      click_link '終了期限でならべかえる'
      expect(task[0]).to have_text 'Amazon定期便'
      
      task[11].click_on '詳細'
      expect(page).to have_selector 'h3', text: '飲み会予約'
    end
  end

  feature "検索機能" do
    let(:task) { all('tr td') }
    scenario "タイトル検索で絞り込めるかのテスト" do
      visit root_path
      save_and_open_page
      fill_in 'タイトル検索', with: '歯医者'
      click_on '検索'
      
      expect(task[1]).to have_text '18時から'
    end

    scenario "ステータス検索で絞り込めるかのテスト" do
      visit root_path

      choose 'task_state_search_2'
      click_on '検索'

      expect(task[0]).to have_text '美容室'
    end

    scenario "タイトルとステータスで絞り込めるかのテスト" do
      visit root_path

      fill_in 'タイトル検索', with: '歯医者'
      choose 'task_state_search_0'
      click_on '検索'

      expect(task[3]).to have_text '未着手'
    end
  end
end