class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[ show update destroy ]

  # GET /comments
  def index
    if params[:post_id]
      @comments = Comment.where(post_id: params[:post_id])
    else
      @comments = Comment.all
    end

    render json: @comments
  end

  # GET /comments/:id
  def show
    render json: @comment.as_json(except: [:user_id, :post_id], include: :user)
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.sentiment = $analyzer.score(comment_params[:content])

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/:id
  def update
    if current_user.id == @comment.user_id
      @comment.sentiment = $analyzer.score(comment_params[:content])
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "Not authorized to edit comment"}, status: :unauthorized
    end
  end

  # DELETE /comments/:id
  def destroy
    if current_user.id == @comment.user_id
      @comment.destroy
    else
      render json: {error: "Not authorized to delete comment"}, status: :unauthorized
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end      
    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end
end
