require 'rails_helper'

RSpec.describe User, type: :model do
  describe "presence: trueのバリデーション" do
    it "nameが空ならバリデーションが通らない" do
      user = User.create(name: "", email: "user@email.com", password: "password")
      expect(user).not_to be_valid
    end

    it "emailが空ならバリデーションが通らない" do
      user = User.create(name: "email空男", email: "", password: "password")
      expect(user).not_to be_valid
    end

    it "passwordが空ならバリデーションが通らない" do
      user = User.create(name: "password空男", email: "user@email.com", password: "")
      expect(user).not_to be_valid
    end

    it "name, email, passwordが入力されていればバリデーションを通過" do
      user = User.create(name: "バリデーション通過マン", email: "user@email.com", password: "password")
      expect(user).to be_valid
    end
  end

  describe "lengthのバリデーション" do
    text = "バリ"
    it "nameが31文字以上ならバリデーションが通らない" do
      user = User.create(name: "#{text * 31}", email: "user@email.com", password: "password")
      expect(user).not_to be_valid
    end

    it "emailが256文字以上ならバリデーションが通らない" do
      user = User.create(name: "#{text * 31}", email: "#{text * 255}" + "@email.com", password: "password")
      expect(user).not_to be_valid
    end

    it "passwordが6文字未満ならバリデーションが通らない" do
      user = User.create(name: "password5文字マン", email: "user@email.com", password: "pass")
      expect(user).not_to be_valid
    end
  end

  describe "email関連のバリデーション" do
    it "一意でなければバリデーションが通らない" do
      user_1 = User.create(name: "user", email: "user@email.com", password: "password")
      user_2 = User.create(name: "email被りマン", email: "user@email.com", password: "password")
      expect(user_2).not_to be_valid
    end

    it "formatが指定通りでなければバリデーションが通らない" do
      user = User.create(name: "user", email: "user-email.com", password: "password")
      expect(user).not_to be_valid
    end
  end
end
