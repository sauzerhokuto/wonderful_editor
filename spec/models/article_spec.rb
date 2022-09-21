# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default("draft"), not null
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
    let(:article) { create(:article, body: nil) }
    it "登録がされない" do
      expect { article }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "正常系" do
    context "タイトルと本文が入力されているとき" do
      let(:article) { create(:article) }

      it "下書き状態の記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が下書き状態のとき" do
      let(:article) { build(:article, :draft) }

      it "下書き状態の記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が公開状態のとき" do
      let(:article) { build(:article, :published) }

      it "公開状態の記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end
end
