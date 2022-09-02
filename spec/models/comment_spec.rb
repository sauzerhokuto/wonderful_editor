# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment, type: :model do
  context "コメントが150文字以内の時" do
    let(:comment) { create(:comment) }
    it "コメント登録が実行される" do
      expect(comment.valid?).to eq true
    end
  end

  context "コメントが空白の時" do
    let(:comment) { create(:comment, body: "") }
    it "コメント登録が実行される" do
      expect { comment }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "コメントが151文字以上の時" do
    let(:comment) { create(:comment, body: "a" * 151) }
    # binding.pry
    it "コメント登録がされない" do
      # binding.pry
      expect { comment }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
