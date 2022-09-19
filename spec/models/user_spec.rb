# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
end
