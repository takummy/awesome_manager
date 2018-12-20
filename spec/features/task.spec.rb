require 'rails_helper'

RSpec.feature  "タスク管理機能", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:label_1) { FactoryBot.create(:label) }
  let(:label_2) { FactoryBot.create(:label, name: "プライベート") }
  let(:now) { Date.current }
  background do
    task = FactoryBot.create(:task, user_id: user.id)
    FactoryBot.create(:task, 
                      title: "美容室",
                      content: "16時から", 
                      expired_at: "#{now}", 
                      state: 2, priority: 0, 
                      created_at: "#{Date.current.yesterday}",
                      user_id: user.id,
                      )
    FactoryBot.create(:task, 
                      title: "歯医者", 
                      content: "18時から", 
                      expired_at: "#{now}", 
                      state: 0, priority: 1, 
                      created_at: "#{Date.current.ago(2.day)}",
                      user_id: user.id
                      )
    FactoryBot.create(:task, 
                      title: "飲み会予約", 
                      content: "海浜幕張のちばチャン19時〜", 
                      expired_at: "#{now.since(1.week)}", 
                      state: 1, 
                      priority: 2, 
                      created_at: "#{Date.current.ago(4.day)}",
                      user_id: user.id
                      )
    FactoryBot.create(:task, 
                      title: "新幹線の予約", 
                      content: "東京駅10時発のやつ", 
                      expired_at: "#{now}", 
                      state: 0, 
                      priority: 0, 
                      created_at: "#{Date.current.ago(3.day)}",
                      user_id: user.id
                      )
    label_1 = FactoryBot.create(:label)
    FactoryBot.create(:label, name: "旅行")
    FactoryBot.create(:label, name: "プライベート")
    FactoryBot.create(:labeling, task_id: task.id, label_id: label_1.id)

    visit root_path
    click_on 'ログイン'

    fill_in 'session[email]', with: "jensen@email.com"
    fill_in 'session[password]', with: "password"

    within ".login_button" do
      click_on "ログイン"
    end
  end

  scenario "タスク一覧のテスト" do
    visit tasks_path

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
    check 'task_label_ids_4'
    check 'task_label_ids_6'

    click_on "登録する"

    expect(page).to have_content "DIC"
    expect(page).to have_content "オリアプを完成させる"
    expect(page).to have_content "2018-12-25"
    expect(page).to have_content "未着手"
    expect(page).to have_content "仕事"
    expect(page).to have_content "プライベート"
  end

  let(:task) { Task.create!(title: "もくもく会",
                            content: "15時〜五反田",
                            expired_at: "#{now}",
                            state: 0,
                            priority: 1,
                            user_id: user.id,
                            label_ids: [label_1.id, label_2.id]
                            ) 
              }

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
      visit tasks_path

      expect(task[15]).not_to have_text '飲み会予約'
      expect(task[32]).to have_text 'Amazon定期便'

      task[13].click_on '詳細'
      expect(page).to have_selector 'h3', text: '海浜幕張のちばチャン19時〜'
    end

    scenario "タスクが終了期限順に並び変わるかのテスト" do
      visit tasks_path
      expect(task[24]).to have_text '美容室'

      click_link '終了期限でならべかえる'
      sorted_tasks = all('tr td')
      expect(sorted_tasks[8]).to have_text '飲み会予約'
    end

    scenario "タスクが優先順位順に並び変わるかのテスト" do
      visit tasks_path
      expect(task[4]).to have_text '低'
      
      click_link '優先順位でならべかえる'
      sorted_tasks = all('tr td')
      expect(sorted_tasks[4]).to have_text '高'
    end
  end

  feature "検索機能" do
    let(:task) { all('tr td') }
    scenario "タイトル検索で絞り込めるかのテスト" do
      visit tasks_path
  
      fill_in 'タイトル検索', with: '歯医者'
      click_on '検索'
      
      expect(task[1]).to have_text '18時から'
    end

    scenario "ステータス検索で絞り込めるかのテスト" do
      visit tasks_path

      choose 'task_state_search_2'
      click_on '検索'

      expect(task[0]).to have_text '美容室'
    end

    scenario "タイトルとステータスで絞り込めるかのテスト" do
      visit tasks_path

      fill_in 'タイトル検索', with: '歯医者'
      choose 'task_state_search_0'
      click_on '検索'
      expect(task[3]).to have_text '未着手'
    end

    scenario "ラベルで絞り込めるかのテスト" do
      visit tasks_path

      choose 'task_label_search_30'
      click_on '検索'
      expect(page).to have_text "Amazon定期便", "仕事"
    end
  end
end