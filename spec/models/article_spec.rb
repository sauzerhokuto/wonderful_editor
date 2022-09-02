# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルと本文が指定されている時" do
    let(:article) { create(:article) }
    it "登録がされる" do
      expect(article).to be_valid
    end
  end

  context "タイトルが指定されていない時" do
    let(:article) { create(:article, title: nil) }
    it "登録がされない" do
      expect { article }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "本文が指定されていない時" do
    user = FactoryBot.create(:user)
    article = user.articles.create!(title: "foo", body: "")
    it "登録がされない" do
      expect(article).to be_invalid
    end
  end
end
