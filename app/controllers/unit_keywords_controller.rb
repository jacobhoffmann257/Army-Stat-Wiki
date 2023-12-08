class UnitKeywordsController < ApplicationController
  before_action :set_unit_keyword, only: %i[ show edit update destroy ]

  # GET /unit_keywords or /unit_keywords.json
  def index
    @unit_keywords = UnitKeyword.all
  end

  # GET /unit_keywords/1 or /unit_keywords/1.json
  def show
  end

  # GET /unit_keywords/new
  def new
    @unit_keyword = UnitKeyword.new
  end

  # GET /unit_keywords/1/edit
  def edit
  end

  # POST /unit_keywords or /unit_keywords.json
  def create
    @unit_keyword = UnitKeyword.new(unit_keyword_params)

    respond_to do |format|
      if @unit_keyword.save
        format.html { redirect_to unit_keyword_url(@unit_keyword), notice: "Unit keyword was successfully created." }
        format.json { render :show, status: :created, location: @unit_keyword }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unit_keywords/1 or /unit_keywords/1.json
  def update
    respond_to do |format|
      if @unit_keyword.update(unit_keyword_params)
        format.html { redirect_to unit_keyword_url(@unit_keyword), notice: "Unit keyword was successfully updated." }
        format.json { render :show, status: :ok, location: @unit_keyword }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit_keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_keywords/1 or /unit_keywords/1.json
  def destroy
    @unit_keyword.destroy

    respond_to do |format|
      format.html { redirect_to unit_keywords_url, notice: "Unit keyword was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_keyword
      @unit_keyword = UnitKeyword.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def unit_keyword_params
      params.require(:unit_keyword).permit(:unit_id, :keyword_id)
    end
end
