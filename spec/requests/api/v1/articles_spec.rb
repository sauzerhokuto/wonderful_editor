require "rails_helper"

RSpec.describe "Articles", type: :request do
  # describe "GET /api/v1/articles" do
  #   subject { get(api_v1_articles_path) }

  #   context "記事のレコードが発行された場合" do
  #     binding.pry
  #     let!(:article1) { create(:article, updated_at: 1.days.ago) }
  #     let!(:article){create(:article)}
  #     let!(:article2) { create(:article, updated_at: 2.days.ago) }
  #     it "記事一覧を取得できる" do
  #       binding.pry
  #       subject
  #       res = JSON.parse(response.body)
  #       a = Article.all.order(updated_at: "DESC")
  #       expect(res.count).to eq 3
  #       expect(res[0].keys).to eq ["id", "title", "updated_at", "user"] # 記事にbodyが含まれていない&更新日が表示
  #       expect(response).to have_http_status(:ok) # 誰でも見れる
  #       expect(a.map {|article_| article_.id }).to eq [article.id, article1.id, article2.id] # idを古い順にならびかえることで更新順かどうかわかる。
  #     end
  #   end
  # end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したID(記事)に接続した時" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }
      it "指定のレコードの取得ができる" do
        subject
        res = JSON.parse(response.body)
        # binding.pry
        # レスポンスが200であること
        expect(response).to have_http_status(:ok)
        # 更新日が返ってくること、指定のレコードが返ってくること
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"]["id"]).to eq article.user_id
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "存在しないID(記事)に接続した時" do
      let(:article_id) { 9999 }
      it "レコードの取得ができない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  # describe "POST /api/v1/articles" d
  #   it "" d
  #   end
  # end

  # describe "PATCH(PUT) /api/v1/articles/:id" d
  #   it "" d
  #   end
  # end

  # describe "DELETE /api/v1/articles/:id" d
  #   it "" d
  #   end
  # end
end
