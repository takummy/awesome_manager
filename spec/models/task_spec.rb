require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "presence: trueのバリデーション" do
    it "titleが空ならバリデーションが通らない" do
      task = Task.new(title: "", content: "titleが空", state: 0)
      expect(task).not_to be_valid
    end

    it "contentが空ならバリデーションが通らない" do
      task = Task.new(title: "contentが空", content: "", state: 0)
      expect(task).not_to be_valid
    end

    it "stateを選択しなければバリデーションが通らない" do
      task = Task.new(title: "state選び", content: "state選択なし", state: "")
      expect(task).not_to be_valid
    end

    it "titleとcontentが記入されていて、stateを選択すればバリデーションを通過" do
      task = Task.new(title: "通過", content: "記載ありで通過！", state: 0)
      expect(task).to be_valid
    end
  end

  describe "lengthのバリデーション" do
    let(:text) { "バリ" }
    it "titleが51文字以上ならバリデーションが通らない" do
      task = Task.new(title: "#{text * 26}", content: "text51文字以上", state: 0)
      expect(task).not_to be_valid
    end

    it "contentが301文字以上ならバリデーションが通らない" do
      task = Task.new(title: "content301文字以上", content: "#{text * 151}", state: 0)
      expect(task).not_to be_valid
    end

    it "titleとcontentが字数制限以内ならバリデーションを通過" do
      task = Task.new(title: "#{text * 25}", content: "#{text * 150}", state: 0)
      expect(task).to be_valid
    end
  end

  describe "scopeのテスト" do
    task1 = Task.create(title: "DIC", content: "オリアプ", expired_at: "#{Date.current.yesterday}", state: 0),
    task2 = Task.create(title: "職歴書", content: "今週中", expired_at: "#{Date.current}", state: 0),
    task3 = Task.create(title: "万葉課題", content: "11月中に", expired_at: "#{Date.current.ago(1.day)}", state: 1),
    task4 = Task.create(title: "耳鼻科", content: "咳止めもらう", expired_at: "#{Date.current.ago(1.week)}", state: 2), 
    task5 = Task.create(title: "就業説明会", content: "火曜日", expired_at: "#{Date.current.since(1.month)}", state: 0)
    
    it "'D'で検索するとtask1が返ってくる" do
      expect(Task.search_title("D")).to include(Task.find_by(title: "DIC"))
                                        #eq(Task.where(title: "DIC"))
    end

    it "未着手(0)で検索するとtask1,task2, task5が返ってくる" do
      expect(Task.search_state(0)).to include(Task.find_by(state: 0))
                                      #eq(Task.where(state: 0))
    end
  end
end