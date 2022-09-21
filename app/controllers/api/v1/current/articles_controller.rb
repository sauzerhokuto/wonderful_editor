module Api::V1
  class Current::ArticlesController < BaseApiController
    before_action :authenticate_user!

    def index
      articles = current_user.articles.published.order(updated_at: "DESC")
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
