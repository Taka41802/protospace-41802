class PrototypesController < ApplicationController
    before_action :set_prototype, only: [:edit, :update, :show, :destroy]
    before_action :authenticate_user!, only: [:new, :update, :edit, :destroy]
    before_action :move_to_index, only: [:update, :edit, :destroy]
  def index
    @prototypes = Prototype.all.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to action: :index
    end
  end

end
