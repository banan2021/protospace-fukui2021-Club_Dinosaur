class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :show, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @prototypes = Prototype.includes(:user).order("updated_at DESC")
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user).order("updated_at DESC")
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    if @prototype.destroy
      redirect_to root_path
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def correct_user
    if current_user.id != @prototype.user_id
      redirect_to root_path
    end
  end
end
