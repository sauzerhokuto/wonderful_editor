require "rails_helper"

# RSpec.describe "Articles", type: :request do
#   describe "GET /api/v1/articles" do
#     subject { get(api_v1_articles_path) }

#     context "記事のレコードが発行された場合" do
#       let(:article1) { create(:article, updated_at: 1.days.ago) }
#       let(:article2) { create(:article, updated_at: 2.days.ago) }
#       let(:article3) { create(:article) }
#       it "記事一覧を取得できる" do
#         subject
#         res = JSON.parse(response.body)
#         article = Article.all.order(updated_at: "DESC")
#         expect(res.count).to eq 53 # 記事一覧が表示される
#         expect(res[0].keys).to eq ["id", "title", "updated_at"] # 記事にbodyが含まれていない&更新日が表示
#         expect(response).to have_http_status(:ok) # 誰でも見れる
#         expect(res.map {|article| [article.id] }).to eq [[1], [2], [3]] # idを古い順にならびかえることで更新順かどうかわかる。
#       end
#     end
#   end

# describe "GET /api/v1/articles/:id" do
#   subject { get(api_v1_articles_path) }

#   it "テスト" do
#   end
# end

# describe "POST /api/v1/articles/:id" d
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
# end
