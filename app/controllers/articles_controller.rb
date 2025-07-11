class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.all
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: "Article créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path, notice: 'Article supprimé avec succès.' }
      format.turbo_stream
    end
  end

  # ✅ Vista por categoría
  CATEGORIES = %w[verre bois metal papier textile] # Ajusta según tus categorías reales

  def category
    @category = params[:category].downcase

    unless CATEGORIES.include?(@category)
      render plain: "Catégorie inconnue", status: :not_found and return
    end

    @articles = Article.where('LOWER(category) = ?', @category)

    if lookup_context.template_exists?(@category, 'articles')
      render @category
    else
      render plain: "Page pour la catégorie non trouvée", status: :not_found
    end
  end



  private

  def set_article
    @article = Article.find_by(id: params[:id])
    redirect_to articles_path, alert: "Article non trouvé" if @article.nil?
  end

  def article_params
    params.require(:article).permit(:name, :description, :price, :stock, :category, :image_url)
  end
end
