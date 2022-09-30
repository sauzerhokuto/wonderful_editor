require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分の公開記事が作成された時" do
      let!(:article) { create(:article, :published, user: current_user) }
      let!(:article1) { create(:article, :published, updated_at: 1.days.ago, user: current_user) }
      let!(:article2) { create(:article, :published) }

      before do
        create(:article, :draft, user: current_user)
      end

      it "自分の公開記事一覧が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 2
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res.map {|d| d["id"] }).to eq [article.id, article1.id]
      end
    end
  end
end
