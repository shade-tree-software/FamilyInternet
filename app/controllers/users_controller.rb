class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    # update each user's properties before sending them out
    @users.each do |user|
      user.update_properties
    end

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
        format.html {redirect_to action: "index", notice: 'User was successfully created.'}
        format.json {render :show, status: :created, location: @user}
      else
        format.html {render :new}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    attrs = user_params.as_json

    # Update only if this is a request to activate or deactivate the user.
    # In addition, activation is allowed only if the user has time remaining.
    # All other change requests are denied.
    valid_request = false
    failure_reason = ''

    if !attrs.has_key?('camera')
      failure_reason = 'Missing param: camera.'
    elsif (attrs['camera'] == 'false' || !attrs['camera']) && @user.role > 0
      failure_reason = 'Camera required.'
    elsif !attrs.has_key?('active')
      failure_reason = 'Missing param: active.'
    elsif (attrs['active'] != 'false' || attrs['active']) && !@user.good_to_go
      failure_reason = 'User cannot be activated right now.'
    else
      valid_request = true
    end

    if valid_request
      begin
        @user.update_internet_state(attrs['active'] == true || attrs['active'] == 'true')
      rescue Exception => e
        valid_request = false
        puts e
      end
    end

    respond_to do |format|
      if valid_request
        format.html {redirect_to action: "index", notice: 'User was successfully updated.'}
        format.json {render :show, status: :ok, location: @user}
      else
        format.html {render :edit}
        format.json {render json: {error: failure_reason}, status: :bad_request}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html {redirect_to users_url, notice: 'User was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:active, :camera)
  end
end
