require "rails_helper"

RSpec.describe User, type: :model do
  context "全カラムの値を指定しているとき" do
    let(:user) { create(:user) }
    it "userのレコードが作成される" do
      # user = User.create(name:"ff",email:"ff",password:"ff")
      # ↑上記がダメな理由を調べる
      expect(user).to be_valid
    end
  end

  context "nameを指定しない時" do
    # user登録において、nameのみ空の状態で登録する
    let(:user) { create(:user, name: nil) }
    it "userの登録ができない" do
      expect { user }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  # context "同一のnameが存在しない時" do
  # 最初に同じテストを実施しているからテストの必要無し

  context "同一のnameが存在する時" do
    # 同じuserの名前を2つ作る
    let(:user) { create_list(:user, 2, name: "foo") }
    it "user登録が実行されない" do
      # validationにかかってエラーが出ればOK
      expect { user }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
