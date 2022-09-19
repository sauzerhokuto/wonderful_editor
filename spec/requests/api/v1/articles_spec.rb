require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    context "記事のレコードが発行された場合" do
      let!(:article1) { create(:article, updated_at: 1.days.ago) }
      let!(:article) { create(:article) }
      let!(:article2) { create(:article, updated_at: 2.days.ago) }
      it "記事一覧を取得できる" do
        subject
        res = JSON.parse(response.body)
        # a = Article.all.order(updated_at: "DESC")
        expect(res.count).to eq 3
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"] # 記事にbodyが含まれていない&更新日が表示
        expect(response).to have_http_status(:ok) # 誰でも見れる
        expect(res.map {|d| d["id"] }).to eq [article.id, article1.id, article2.id]
        # expect(a.map {|article_| article_.id }).to eq [article.id, article1.id, article2.id] idを古い順にならびかえることで更新順かどうかわかる。
      end
    end
  end

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

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    context "適切なパラメーターを送信した時" do
      let(:current_user) { create(:user) }
      let(:params) { { article: attributes_for(:article) } }
      let(:headers) { current_user.create_new_auth_token }

      it "レコードが発行される" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["title"]).to eq params[:article][:title]
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(res["user"]["id"]).to eq current_user.id
      end
    end

    context "不適切なパラメータを送信した時" do
      let(:current_user) { create(:user) }
      let(:params) { attributes_for(:article) }
      let(:headers) { current_user.create_new_auth_token }

      it "レコードが発行されない" do
        expect { subject }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "PATCH(PUT) /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:params) { { article: { title: "aaa", created_at: 1.day.ago } } }
    let(:headers) { current_user.create_new_auth_token }

    context "適切なパラメータを送信した時" do
      let(:article_id) { article.id }
      let(:article) { create(:article, user_id: current_user.id) }
      it "指定した内容だけレコードが更新される" do
        expect { subject }.to change { Article.find(article_id).title }.from(article.title).to(params[:article][:title])
        not_change { Article.find(article_id).body }
        not_change { Article.find(article_id).created_at }
        expect(response).to have_http_status(:ok)
      end
    end

    context "不適切なパラメータを送信した時" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "指定した内容だけレコードが更新される" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }
    let(:article_id) { article.id }
    let(:headers) { current_user.create_new_auth_token }

    context "対象のレコードを削除しようとした時" do
      let!(:article) { create(:article, user: current_user) }

      it "対象のレコードが削除される" do
        expect { subject }.to change { Article.count }.by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context "対象ではないレコードを削除しようとした時" do
      let!(:article) { create(:article) }

      it "レコードの削除ができない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
