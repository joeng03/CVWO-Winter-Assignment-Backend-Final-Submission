class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_params, only: %i[index]
  before_action :set_post, only: %i[ show update destroy ]

  # GET /posts
  def index
    if @topics 
      @posts = Post.where(topic_id: @topics)
    else 
      @posts = Post.all
    end
    
    if @column_name && @search_value
      @posts=@posts.contains(@column_name, @search_value)
    end

    if @sort_by
      if @sort_by == "stars"
        @posts = @posts.stars_ranked
      elsif @sort_by == "comments"
        @posts = @posts.comments_ranked
      else
        @posts = @posts.order(@sort_by)
      end
    end 

    @posts=@posts.page @page
    
    render json: @posts
  end

  # GET /posts/:id
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    
    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    # A user can update a post only if they wrote it 
    if current_user.id == @post.user_id
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "Not authorized to edit post"}, status: :unauthorized
    end
  end

  # DELETE /posts/:id
  def destroy
    # A user can delete a post only if they wrote it

    if current_user.id == @post.user_id
      @post.destroy
    else  
      render json: {error: "Not authorized to delete post"}, status: :unauthorized
    end
  end

  private

    def set_params
      @page = params[:page].present? ? params[:page].to_i : 1
      @topics = params[:topics]
      @column_name = params[:columnName]
      @search_value = params[:searchValue]
      @sort_by = params[:sortBy]
    end 

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:topic_id, :title, :content, :image)
    end
end