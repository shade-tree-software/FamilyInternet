class InfoMessagesController < ApplicationController
  before_action :set_info_message, only: [:show, :edit, :update, :destroy]

  # GET /info_messages
  # GET /info_messages.json
  def index
    @info_messages = InfoMessage.all
  end

  # GET /info_messages/1
  # GET /info_messages/1.json
  def show
  end

  # GET /info_messages/new
  def new
    @info_message = InfoMessage.new
  end

  # GET /info_messages/1/edit
  def edit
  end

  # POST /info_messages
  # POST /info_messages.json
  def create
    @info_message = InfoMessage.new(info_message_params)

    respond_to do |format|
      if @info_message.save
        format.html { redirect_to @info_message, notice: 'Info message was successfully created.' }
        format.json { render :show, status: :created, location: @info_message }
      else
        format.html { render :new }
        format.json { render json: @info_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /info_messages/1
  # PATCH/PUT /info_messages/1.json
  def update
    respond_to do |format|
      if @info_message.update(info_message_params)
        format.html { redirect_to @info_message, notice: 'Info message was successfully updated.' }
        format.json { render :show, status: :ok, location: @info_message }
      else
        format.html { render :edit }
        format.json { render json: @info_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /info_messages/1
  # DELETE /info_messages/1.json
  def destroy
    @info_message.destroy
    respond_to do |format|
      format.html { redirect_to info_messages_url, notice: 'Info message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_info_message
      @info_message = InfoMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def info_message_params
      params.require(:info_message).permit(:text)
    end
end
