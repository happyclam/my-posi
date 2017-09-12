class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.page(params[:page])

  end

  # GET /users/1
  # GET /users/1.json
  # def show
  # end

  # # GET /users/new
  # def new
  #   @user = User.new

  # end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @user }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
#    if @user.update_attributes(params[:user])
        flash[:notice] = "更新しました。"
    else
        flash[:notice] = "既に使用されています。更新は失敗しました。"
    end

    respond_to do |format|
      format.html { redirect_to users_path(:page => session[:page]) }
      format.json { head :no_content }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
#      params.require(:user).permit(:name, :provider, :screen_name, :uid)
      params.require(:user).permit(:name, :screen_name)
    end
end
