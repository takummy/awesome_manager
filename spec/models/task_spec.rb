require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "presence: trueのバリデーション" do
    it "titleが空ならバリデーションが通らない" do
      task = Task.new(title: "", content: "titleが空")
      expect(task).not_to be_valid
    end

    it "contentが空ならバリデーションが通らない" do
      task = Task.new(title: "contentが空", content: "")
      expect(task).not_to be_valid
    end

    it "titleとcontentが記入されていればバリデーションを通過" do
      task = Task.new(title: "通過", content: "記載ありで通過！")
      expect(task).to be_valid
    end
  end

  describe "lengthのバリデーション" do
    let(:text) { "バリ" }
    it "titleが51文字以上ならバリデーションが通らない" do
      task = Task.new(title: "#{text * 26}")
      expect(task).not_to be_valid
    end

    it "contentが301文字以上ならバリデーションが通らない" do
      task = Task.new(title: "content301文字以上", content: "#{text * 151}")
      expect(task).not_to be_valid
    end

    it "titleとcontentが字数制限以内ならバリデーションを通過" do
      task = Task.new(title: "#{text * 25}", content: "#{text * 150}")
      expect(task).to be_valid
    end
  end
end