module Api::V1
  class ArticlesController < BaseApiController
    # def index
    #   articles = Article.all.order(updated_at: "DESC")
    #   # レスポンスの値(id,title,updated_at)が複数の場合、 each_serializer を使用する。
    #   render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    # end

    # def show
    #   article = Article.find(params[:id])
    #   render json: article, serializer: Api::V1::ArticlePreviewSerializer
    # end

    def create
      article = current_user.articles.create!(article_params)
      render json: article, serializer: Api::V1::ArticlePreviewSerializer
    end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end
