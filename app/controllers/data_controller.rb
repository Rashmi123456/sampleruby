require 'httparty'

class DataController < ApplicationController
   before_action :set_datum, only: [:show, :edit, :update, :destroy]

  # GET /data
  def index
    @data = Datum.all
  end

  # GET /data/1
  def show
  end

  # GET /data/new
  def new
    @datum = Datum.new
  end

  # GET /data/1/edit
  def edit
  end

  # POST /data
  def create
    @datum = Datum.new(datum_params)

    if @datum.save
      notify_endpoints(@datum)
      redirect_to @datum, notice: 'Datum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /data/1
  def update
    if @datum.update(datum_params)
      notify_endpoints(@datum)
      redirect_to @datum, notice: 'Datum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /data/1
  def destroy
    @datum.destroy
    redirect_to data_url, notice: 'Datum was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datum
      @datum = Datum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def datum_params
      params.require(:datum).permit(:name, :data)
    end

    private

  def notify_endpoints(datum)
    third_party_endpoints = Rails.application.config.third_party_endpoints || []
    third_party_endpoints.each do |endpoint|
      response = HTTParty.post(endpoint, body: { datum: datum.as_json }, headers: { 'Content-Type' => 'application/json' })
      # Handle response if needed
    end
  end
end

