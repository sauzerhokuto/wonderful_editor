require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  let(:current_user) { create(:user) }
  let(:headers) { current_user.create_new_auth_token }

  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "自分の下書き記事が作成された時のみ" do
      let!(:article) { create(:article, :draft, user: current_user) }
      let!(:article1) { create(:article, :draft, updated_at: 1.days.ago, user: current_user) }
      let!(:article2) { create(:article, :draft) }

      it "自分のレコードが取得できる" do
        subject
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res.count).to eq 2
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"]
        expect(res.map {|d| d["id"] }).to eq [article.id, article1.id]
      end
    end

    context "自分の記事が公開状態の時" do
      let!(:article) { create(:article, :published, user: current_user) }
      it "記事の取得ができない" do
        subject
        res = JSON.parse(response.body)
        expect(res.count).to eq 0
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article.id), headers: headers) }

    context "自分の下書き記事が作成された時" do
      let(:article) { create(:article, :draft, user: current_user) }

      it "記事の取得ができる" do
        subject
        expect(response).to have_http_status(:ok)
        res = JSON.parse(response.body)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user_id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "自分の記事が公開状態の時" do
      let(:article) { create(:article, :published, user: current_user) }

      it "記事の取得ができない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
