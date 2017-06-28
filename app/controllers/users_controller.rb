class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.json {render json: @users}
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
      format.json {render json: @user}
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to action: "index", notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      attrs = user_params.as_json
      expiration_time = @user.expiration || Time.now.to_i
      # If switching from inactive to active user, set new expiration time
      # based on previously stored countdown value
      if @user.active == false && (attrs['active'] == 'true' || attrs['active'] == true)
        attrs[:expiration] = expiration_time = Time.now.to_i + @user.countdown
      end

      #TODO: fail update if active requested but no minutes remaining

      # Update countdown based on difference between current time and expiration time
      secs_left = (expiration_time - Time.now.to_i)
      secs_left = secs_left >= 0 ? secs_left : 0
      attrs[:countdown] = secs_left
      puts attrs
      if @user.update(attrs)
        format.html { redirect_to action: "index", notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
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
      params.require(:user).permit(:active)
    end
end
