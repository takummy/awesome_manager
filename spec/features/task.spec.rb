require 'rails_helper'

RSpec.feature  "タスク管理機能", type: :feature do
  scenario "タスク一覧のテスト" do
    Task.create!(title: "テスト_1", content: "テスト")
    Task.create!(title: "テスト_2", content: "テストテスト")

    visit root_path

    expect(page).to have_content "テスト"
    expect(page).to have_content "テストテスト"
  end

  scenario "タスク作成のテスト" do
    visit new_task_path

    fill_in 'Title', with: "DIC"
    fill_in 'Content', with: "オリアプを完成させる"

    click_on "Create Task"
    
    expect(page).to have_content "DIC"
    expect(page).to have_content "オリアプを完成させる"
  end

  let(:task) { Task.create!(title: "テスト_3", content: "テストテストテスト") }
  scenario "タスク詳細のテスト" do
    visit task_path(task.id)

    expect(page).to have_content "テスト_3"
    expect(page).to have_content "テストテストテスト"
  end
end