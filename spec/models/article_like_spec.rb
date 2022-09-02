# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "いいねしていないユーザーがいいねした時" do
    # いいねは「ArticleLikeの主キーが発行された状態」だからカラムはないがcreateしてあげる
    let(:article_like) { create(:article_like) }
    it "いいねの登録がされる" do
      expect(article_like).to be_valid
    end
  end

  context "user_idとarticle_idが同じ場合" do
    user = FactoryBot.create(:user)
    article = FactoryBot.create(:article)
    let(:article_like) { 2.times { create(:article_like, user_id: user.id, article_id: article.id) } }
    it "複数回いいねの登録ができない" do
      expect { article_like }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
