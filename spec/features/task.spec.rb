require 'rails_helper'

RSpec.feature  "タスク管理機能", type: :feature do
  background do
    FactoryBot.create(:task)
    FactoryBot.create(:task, title: "テスト_2", content: "テストテスト")
  end
  scenario "タスク一覧のテスト" do
    visit root_path

    expect(page).to have_content "テスト"
    expect(page).to have_content "テストテスト"
  end

  scenario "タスク作成のテスト" do
    visit new_task_path

    fill_in 'タスク名', with: "DIC"
    fill_in '内容', with: "オリアプを完成させる"

    click_on "登録する"
    
    expect(page).to have_content "DIC"
    expect(page).to have_content "オリアプを完成させる"
  end

  let(:task) { Task.create!(title: "テスト_3", content: "テストテストテスト") }
  scenario "タスク詳細のテスト" do
    visit task_path(task.id)

    expect(page).to have_content "テスト_3"
    expect(page).to have_content "テストテストテスト"
  end

  scenario "タスク一覧が作成日時順に並んでいるかのテスト" do

  end
end